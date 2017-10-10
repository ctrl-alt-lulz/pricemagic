class RecurringCharge < Charge
  validates :shopify_id, presence: true
  validates :shop_id, presence: true
  validates :charge_data, presence: true
  
  belongs_to :shop

  before_destroy :destroy_on_shopify!
  before_validation :store_charge_data
  
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
    self.charge_data = ShopifyAPI::RecurringApplicationCharge.create(
      name: "Paid Price Test Subscription",
      price: 19.99,
      return_url: "https:\/\/price-magic-bytesize.c9users.io\/recurring_charges_activate", ## TODO set up an environment variable
      test: true, ## Use ENV['SHOPIFY_CHARGE_TEST']
      terms: "$19.99 per month for up to 50 tests"
    ).attributes
  end
  
  private
  
  ## TODO create better handling to ensure someone's shopify recurring charge 
  ## is destroyed on rescue
  def destroy_on_shopify!
    begin
      ShopifyAPI::RecurringApplicationCharge.find(shopify_id).destroy
    rescue ActiveResource::ResourceInvalid => e
      puts '*'*50
      puts e.inspect
    end
  end

end