class RecurringCharge < Charge
  validates :shopify_id, presence: true
  validates :shop_id, presence: true
  
  belongs_to :shop

  before_destroy :destroy_on_shopify!

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