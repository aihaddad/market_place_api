require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns a json with the right product" do
      expect(json_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end #show

  describe "GET #index" do
    before do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 json records from the database" do
      expect(json_response[:products].size).to eql 4
    end

    it { should respond_with 200 }
  end
end
