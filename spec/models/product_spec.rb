require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.build :product }
  subject { product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  it { should_not be_published }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to 0 }
  it { should validate_presence_of :user_id }

  it { should belong_to :user }
  
  describe "organized" do
      before(:each) do
        @product1 = FactoryGirl.create :product, title: "A plasma TV",    price: 100
        @product2 = FactoryGirl.create :product, title: "Fastest Laptop", price: 50
        @product3 = FactoryGirl.create :product, title: "CD player",      price: 150
        @product4 = FactoryGirl.create :product, title: "LCD TV",         price: 99
      end
    
    describe "with title filter set to 'TV'" do
      it "returns only 2 products" do
        expect(Product.filter_by_title("TV").size).to eql 2
      end

      it "returns the matching products" do
        expect(Product.filter_by_title("TV").sort).to match_array([@product1, @product4])
      end
    end # title filter

    describe "with price filter" do
      context "above certain price" do
        it "returns the products which are above or equal to filter" do
          expect(Product.above_or_equal_to_price(100).sort).to match_array([@product1, @product3])
        end
      end

      context "below certain price" do
        it "returns the products which are below or equal to filter" do
          expect(Product.below_or_equal_to_price(99).sort).to match_array([@product2, @product4])
        end
      end
    end # price filter
    
    describe "with decending sort by most recent" do
      before do
        @product2.touch
        @product3.touch
      end
      
      it "returns the most recently updated first" do
        expect(Product.recent).to match_array([@product3, @product2, @product4, @product1])
      end
    end # sort most recent
  end
end
