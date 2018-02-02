class RecurringCharge < Charge
  validates :shopify_id, presence: true
  validates :shop_id, presence: true
  validates :charge_data, presence: true
  
  belongs_to :shop
  after_initialize :store_charge_data
  before_destroy :destroy_on_shopify!

  def active?
    charge_data['status'] == 'active'
  end

  def charge_data=(data)
    self.shopify_id = data['id']
    super
  end
  
  def name
    charge_data['name']
  end
  
  def price
    charge_data['price']
  end
  
  def billing_on
    charge_data['billing_on']
  end
  
  def confirmation_url
    charge_data['confirmation_url']
  end

  def store_charge_data
    begin
      self.charge_data = ShopifyAPI::RecurringApplicationCharge.create(
        name: "Paid Price Test Subscription",
        price: 19.99,
        return_url: Rails.configuration.public_url + 'recurring_charges_activate',
        test: check_plan_type,
        trial_days: 14,
        terms: "$19.99 per month for unlimited tests"
      ).attributes
    rescue => e
      puts e.inspect
    end
  end

  def update_charge_data(params)
    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
    charge_data['status'] = "active"
    if recurring_application_charge.status.eql? "accepted"
      recurring_application_charge.activate
      self.update_attributes!(charge_data: charge_data.merge(recurring_application_charge.attributes))
      return true
    else
      return false
    end
  end
  
  private

  def check_plan_type
    if ShopifyAPI::Shop.current.attributes["plan_name"] == "affiliate"
      Shop.find(shop_id).update_attributes(affiliate: true)
      return true
    end
  end

  ## TODO create better handling to ensure someone's shopify recurring charge 
  ## is destroyed on rescue
  def destroy_on_shopify!
    DestroyExtShopifyChargeWorker.perform_async(shop_id)
    StopPriceTestsWorker.perform_async(shop_id)
  end

end
