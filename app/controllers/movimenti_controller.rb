class MovimentiController < ApplicationController
  
  load_and_authorize_resource
  
  def create
    
    @articolo = Articolo.find_by_id(params[:movimento][:articolo_id])
    
    if @articolo
      if @articolo.disponibile?
        @movimento = Movimento.create(params[:movimento].merge(tipo: "vendita"))
        respond_to do |format|
          format.html { redirect_to cassa_path }
          format.js
        end
      else
        flash[:error] = "Articolo non disponbile!"
        redirect_to cassa_path
      end 
    else
      flash[:error] = "Codice articolo non trovato!"
      redirect_to cassa_path
    end    
  end
  
  def destroy
    @movimento = Movimento.find(params[:id])
    @movimento.destroy

    respond_to do |format|
      format.html { redirect_to cassa_path}
      format.js
    end
  end
    
end
