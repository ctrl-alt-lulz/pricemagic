class Collection < ActiveRecord::Base
    # verify all items belong to shop
    #belongs_to :shop #verify
    has_many :collects
    has_many :products, through: :collects
end
