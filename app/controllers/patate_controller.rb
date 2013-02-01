class PatateController < ApplicationController
  
  def index
  	
    @patate_mangiate    = Movimento.vendita.select {|m| m.patate? == true} 
  	
    @patate_da_mangiare = 
  		Articolo.registrato.disponibili.order("articoli.documento_id desc, articoli.id").select do |a|
  		  a.patate? == true
      end

       
  end
end
