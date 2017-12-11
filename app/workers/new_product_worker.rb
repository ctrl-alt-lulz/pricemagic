class NewProductWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(shopify_product_id, title, id, product_type, tags, variants)
    puts variants
    puts '*' * 50
    puts variants.first
    puts '*' * 50

    shop = Shop.find(id)
    new_product = shop.products.new(title: title, shopify_product_id: shopify_product_id,
                                    product_type: product_type, tags: tags,
                                    shop_id: shop.id)
    variants.each do |variant|
      new_product.variants.new(shopify_variant_id: variant['id'], variant_title: variant['title'],
                               variant_price: variant['price'])
    end
    new_product.save
    shop.seed_collects!
  end
end