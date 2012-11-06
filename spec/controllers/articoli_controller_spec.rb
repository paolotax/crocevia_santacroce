require 'spec_helper'

describe ArticoliController do

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
        @ability.can :read, Articolo
        @cliente = FactoryGirl.create(:cliente)
      end
      
      xit "assigns all articoli to @articoli with mock" do
        articolo = stub_model(Articolo)  # devo assegnare il cliente
        Articolo.stub(:all) { [articolo] }
        get :index
        assigns(:articoli).should eq([articolo])
      end

      it "render index" do
        get :index
        response.should render_template("index")
      end
      
      it "assigns all articoli to @articoli" do
        articolo = @cliente.articoli << FactoryGirl.create(:articolo)
        get :index
        assigns(:articoli).all.should eq(articolo)
      end
      
      it "returns max 30 @articoli per page" do
        (0..35).each { @cliente.articoli << FactoryGirl.create(:articolo) }
        get :index
        assigns(:articoli).all.size.should eq(30)
      end
    end  
  end

end
