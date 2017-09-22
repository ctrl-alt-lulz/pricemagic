require 'rails_helper'

describe PriceTest, type: :model do
  it "has a valid factory" do
    expect(create(:price_test)).to be_valid
  end
end