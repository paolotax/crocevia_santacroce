class CodiceFiscaleController < ApplicationController
  
  def create
    @codice_fiscale = CodiceFiscale.new(params[:cliente])
    render json: @codice_fiscale.to_json
  end
  
end
