require "prawn/measurement_extensions"

class ArticoliController < ApplicationController
  
  load_and_authorize_resource

  def index
    @q = Articolo.includes(:cliente).joins(:cliente).order("articoli.id desc").search(params[:q])
    @articoli = @q.result(:distinct => true).pagina(params[:page]).per(30)
  end
 
  def create
    @articolo = Articolo.create(params[:articolo])
    
    respond_to do |format|
      format.html { redirect_to @articolo.cliente }
      format.js
    end
  end
  
  def destroy
    @articolo.destroy
    respond_to do |format|
      format.html { redirect_to @articolo.cliente }
      format.js
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @articolo.update_attributes(params[:articolo])
      redirect_to @articolo, notice: "Articolo modificato."
    else
      render :edit
    end
  end
  
  def etichette
    @articoli = Articolo.order(:id).find(params[:articolo_ids])
    
    respond_to do |format|
      format.pdf do
        
        case params[:tipo_etichetta]
          when "Dymo 11352"
            options = {
              page_size:  [25.mm, 54.mm],
              labels_per_page: 1,
              columns: 1
            }
        end  

        pdf = EtichettaPdf.new(@articoli, view_context, options)
        send_data pdf.render, filename: "etichette_#{Time.now}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end    
end
