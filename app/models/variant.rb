class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :metrics, dependent: :destroy
end
