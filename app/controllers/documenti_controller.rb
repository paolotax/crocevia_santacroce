class DocumentiController < ApplicationController

  load_and_authorize_resource
  
  def index
    @documenti = Documento.all
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @documento }
    end
  end

  def new
    @documento = Documento.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @documento }
    end
  end

  def edit
  end

  def create
    @documento = Documento.new(params[:documento])
    
    if params[:documento][:tipo] == 'cassa'
      @documento.add_movimenti_attivi(current_user)
    end

    respond_to do |format|
      if @documento.save
        format.html { redirect_to cassa_path, notice: "Documento di #{@documento.tipo} registrato!" }
        format.json { render json: @documento, status: :created, location: @documento }
      else
        format.html { redirect_to cassa_path, error: "Errore nella registrazione!" }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @documento.update_attributes(params[:documento])
        format.html { redirect_to @documento, notice: 'Documento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @documento.destroy
    respond_to do |format|
      format.html { redirect_to documenti_url }
      format.json { head :no_content }
    end
  end
end
