class Collection < ActiveRecord::Base
  # verify all items belong to shop
  belongs_to :shop #verify
  has_many :collects
  has_many :products, through: :collects
  before_destroy :delete_collects

  private

  def delete_collects
    Collect.where(collection_id: id).destroy_all
  end
end
