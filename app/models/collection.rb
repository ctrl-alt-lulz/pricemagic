class Collection < ActiveRecord::Base
    has_many :collects
    has_many :products, through: :collects
end
