require 'rails_helper'

describe Shop, type: :model do
  
  it "has a valid factory" do
    expect(create(:shop)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:users).dependent(:destroy).order(updated_at: :desc) }
    it { should have_many(:metrics).dependent(:destroy).order(created_at: :asc) }
    it { should have_many(:products).dependent(:destroy) }
    it { should have_many(:price_tests).through(:products) }
    
    it { should have_many(:collects).through(:products).dependent(:destroy) }
    it { should have_many(:collections).through(:collects).conditions(:uniq) }
  end

  describe "validations" do
    it { should validate_presence_of(:shopify_domain) }
    it { should validate_presence_of(:shopify_token) }
  end

  describe '#latest_metric' do
    let!(:shop) { create(:shop) }
    let!(:metric) { create(:metric, shop: shop) }
    
    it 'should be the most recently created metric' do
      expect(shop.latest_metric).to eq metric
    end
  end
  
  describe '#trial?' do
    let(:shop) { create(:shop) }
    
    describe "with no existing price test" do
      it 'should be true' do
        expect(shop.trial?).to be_truthy
      end
    end
    
    describe "with existing price tests" do
      let(:product) { create(:product, shop: shop) }
      let!(:price_test) { create(:price_test, product: product) }
      
      it 'should be false' do
        expect(shop.trial?).to be_falsey
      end
    end
  end
  
  describe '#has_subscription?' do
    describe "with a subscription" do
      it "should be true"
    end
    
    describe "with a subscription" do
      it "should be false"
    end
  end
end
