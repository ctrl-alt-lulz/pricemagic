class User < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :shop_id
  scope :with_access_token, -> { where.not(google_access_token: nil) }
  scope :with_refresh_token, -> { where.not(google_refresh_token: nil) }
end
