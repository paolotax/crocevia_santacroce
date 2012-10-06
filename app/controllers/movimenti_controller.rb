class MovimentiController < ApplicationController
  
  load_and_authorize_resource
 
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
  
  def destroy
    @movimento = Movimento.find(params[:id])
    @movimento.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice:  'Movimento eliminato!.'  }
      format.js
    end
  end
    
end
