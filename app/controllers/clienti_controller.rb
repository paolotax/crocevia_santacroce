class ClientiController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @q = Cliente.includes(:articoli).order("id desc").search(params[:q])
    @clienti = @q.result(distinct: true).pagina(params[:page]).per(10)
  end
  
  def show
    @cliente = Cliente.includes(:articoli).find(params[:id])
    
    if request.path != cliente_path(@cliente)
      redirect_to @cliente, status: :moved_permanently
    end
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
  
  def mandato
  end
  
  def crea_codice_fiscale
    @codice_fiscale = CodiceFiscale.new(@cliente)
    render json: @codice_fiscale.to_json
  end
  
end
