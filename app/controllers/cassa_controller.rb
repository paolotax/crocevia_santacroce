class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento = Movimento.new(tipo: "vendita")
  end

end
