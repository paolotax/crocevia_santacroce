class ClientiController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @clienti = Cliente.order('created_at desc').page(params[:page]).per_page(20)
  end
  
  def show
  end
  
  def new
  end  

  def create
    if @cliente.save
      redirect_to clienti_path, notice: "Cliente inserito con successo!"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @cliente.update_attributes(params[:cliente])
      redirect_to @cliente, notice: "Cliente modificato."
    else
      render :edit
    end
  end
  
  def destroy
    @cliente.destroy
    redirect_to clienti_path, notice: "Cliente eliminato!."
  end
end
