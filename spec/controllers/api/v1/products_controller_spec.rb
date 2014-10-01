require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns a json with the right product" do
      expect(json_response[:product][:title]).to eql @product.title
    end
    
    it "has user details i" do
      
    end

    it { should respond_with 200 }
    
    it "has user details embedded inside" do
      expect(json_response[:product][:user][:email]).to eql @product.user.email
    end
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
    
    it "returns the user object into each product" do
      json_response[:products].each do |product_response|
        expect(product_response[:user]).to be_present
      end
    end
  end #index

  describe "POST #create" do
    
    context 'when successfully created' do
      before do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders json for the product just created" do
        expect(json_response[:product][:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when it is not created' do
      before do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "hundred dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json clarifying reasons for the error" do
        expect(json_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end #create

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
              product: { title: "An expensive TV" } }
      end

      it "renders json for the product just updated" do
        expect(json_response[:product][:title]).to eql "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context "when it is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
              product: { price: "two hundred" } }
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json clarifying reasons for the error" do
        expect(json_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end #update

  describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end #destroy
end
