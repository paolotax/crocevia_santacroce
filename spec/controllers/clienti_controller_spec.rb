require 'spec_helper'

describe ClientiController do
  
  describe "GET index" do
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
    end
    
    context "if not authorized" do
      it "render home page" do
        get :index
        response.should redirect_to(root_path)
      end
    end

    context "if authorized" do
      before(:each) do
        @ability.can :read, Cliente
        @cliente = FactoryGirl.create(:cliente)
      end

      it "render index" do
        get :index
        response.should render_template("index")
      end
      
      it "assigns all clienti to @clienti" do
        get :index
        assigns(:clienti).all.should eq([@cliente])
      end
      
      it "returns max 10 @clienti per page" do
        (0..35).each { FactoryGirl.create(:cliente) }
        get :index
        assigns(:clienti).all.size.should eq(10)
      end
    end  
  end
  

end
