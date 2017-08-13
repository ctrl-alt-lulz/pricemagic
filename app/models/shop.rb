class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :users, dependent: :destroy
  has_many :metrics, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :price_tests, through: :products

  def latest_metric
    metrics.order(created_at: :asc).last
  end

  def latest_access_token
    users.order(updated_at: :desc).where.not(google_access_token: nil).first.google_access_token
  end
  
  def latest_refresh_token
    users.order(updated_at: :desc).where.not(google_refresh_token: nil).first.google_refresh_token
  end
  
  def google_profile_id
    users.order(updated_at: :desc).first.google_profile_id
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
  
  def seed_products!
    shop = self.with_shopify!
    products = (1..(ShopifyAPI::Product.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::Product.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    # create local products
    products.each do |product|
      ## What if product title changes? update attribute condition?
      ## What about deleting products that don't exist anymore?
      next if Product.where(shopify_product_id: product.id).any?
      p = Product.new(title: product.title, shopify_product_id: product.id,
                      product_type: product.product_type, tags: product.tags)
      p.save
      puts p.errors.inspect if p.errors.any?
    end
    puts Product.count
  end
  
  def seed_variants!
    ## Move variant code here so you get reuse inside of your workers
  end
end
