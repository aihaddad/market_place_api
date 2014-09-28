require 'spec_helper'

describe Api::V1::UsersController do

  describe "GET #show" do
    before :each do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it { should respond_with 200 }

    it "returns the right user information" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end
  end #show

  describe "POST #create" do

    context "when record is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "renders the json for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when email is not given" do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json clarifying reasons for the error" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end #create

  describe "PUT/POST #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end

    context 'when record is updated successfully' do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "newemail@example.com" } }
      end

      it "renders the json for the user record just updated" do
        user_response = json_response
        expect(user_response[:email]).to eql "newemail@example.com"
      end

      it { should respond_with 200 }
    end

    context 'with bad email' do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "badmail.com" } }
      end

      it "renders and errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json clarifying reasons for the error" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end #update

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }
  end #destroy
end
