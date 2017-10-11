require 'rails_helper'

describe PriceTest, type: :model do
  it "has a valid factory" do
    expect(create(:price_test)).to be_valid
  end
  
  describe "validations" do
    let(:product) { create(:product) } 
    let(:price_test) { build(:price_test, product: product) } 
    let(:shop) { product.shop }
    
    before(:each) { price_test.save }
    
    describe "trial_or_subscription" do
      describe "with a trial" do
        before(:each) do 
          allow(shop).to receive(:trial?).and_return(true)
        end
        
        it "should be valid" do
          expect(price_test).to be_valid
        end
      end
      
      describe "with a subscription" do
        before(:each) do 
          allow(shop).to receive(:has_subscription?).and_return(true)
        end
        
        it "should be valid" do
          expect(price_test).to be_valid
        end
      end
      
      describe "without a trial or subscription" do
        before(:each) do 
          allow(shop).to receive(:trial?).and_return(false)
          allow(shop).to receive(:has_subscription?).and_return(false)
        end
        
        it "should be valid" do
          expect(price_test).to_not be_valid
        end
      end
    end
  end
end