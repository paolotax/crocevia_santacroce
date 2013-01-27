class MovimentiController < ApplicationController
  
  load_and_authorize_resource
  
  include DisplayCase::ExhibitsHelper

  def index
    @movimenti = Movimento.registrato.includes(:articolo, :documento)
                    .filtra(params).order("documenti.data desc, documenti.id desc, movimenti.id desc")
                    .pagina(params[:page]).per(30)

    @movimenti_per_giorno = @movimenti.group_by {|m| m.documento.data}
  end
  
  def create
    @movimento = current_user.movimenti.build(params[:movimento]) 
    respond_to do |format|
      if @movimento.save
        format.html { redirect_to :back, notice:  'Movimento inserito!.' }
        format.js
      else
        format.js
        format.html { redirect_to :back, error: @movimento.errors.values.join }
      end
    end
  end

  def show
  end

  def destroy
    @movimento = Movimento.find(params[:id])
    @movimento.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice:  'Movimento eliminato!.'  }
      format.js
    end
  end

  def update
    @movimento.update_attributes(params[:movimento])
    respond_with_bip @movimento
  end    

end
