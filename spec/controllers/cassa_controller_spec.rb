require 'spec_helper'

describe CassaController do
  
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end
  
  describe "GET 'index'" do
    it "returns http success" do
      @ability.can :index, :cassa
      @user = FactoryGirl.create(:user)
      controller.stub(:current_user).and_return(@user)
      get 'index'
      response.should be_success
    end
  end

end
