class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @hello_world_props = { name: "Stranger" }
    @product_count = ShopifyAPI::Product.count
    #@collection_ids = ShopifyAPI::Product.find(:all)
    #@products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})

    @collections = []
    @cc = ShopifyAPI::CustomCollection.find(:all, :params => {:limit => 250})
    @cc.each do |c|
      @collections << c
    end

    @sc = ShopifyAPI::SmartCollection.find(:all, :params => {:limit => 250})
    @sc.each do |c|
      @collections << c
    end
  end

  def show
    #get the product by id
    @product_count = ShopifyAPI::Product.count

  end
end
