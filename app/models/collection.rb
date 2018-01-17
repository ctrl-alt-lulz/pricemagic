class Collection < ActiveRecord::Base
  # verify all items belong to shop
  belongs_to :shop #verify
  has_many :collects, dependent: :destroy
  has_many :products, through: :collects

end
