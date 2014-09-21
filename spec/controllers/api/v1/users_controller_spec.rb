require 'spec_helper'

describe Api::V1::UsersController do

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it { should respond_with 200 }

    it "returns the right user information" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email 
    end
  end 

end
