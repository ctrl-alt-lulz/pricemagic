class User < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :shop_id

end
