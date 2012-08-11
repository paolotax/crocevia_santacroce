
class DocumentiController < ApplicationController
  # GET /documenti
  # GET /documenti.json
  def index
    @documenti = Documento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documenti }
    end
  end

  # GET /documenti/1
  # GET /documenti/1.json
  def show
    @documento = Documento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @documento }
    end
  end

  # GET /documenti/new
  # GET /documenti/new.json
  def new
    @documento = Documento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @documento }
    end
  end

  # GET /documenti/1/edit
  def edit
    @documento = Documento.find(params[:id])
  end

  # POST /documenti
  # POST /documenti.json
  def create
    @documento = Documento.new(params[:documento])
    
    if params[:documento][:tipo] == 'cassa'
      @documento.add_movimenti_attivi(current_user)
    end

    respond_to do |format|
      if @documento.save
        format.html { redirect_to @documento, notice: 'Documento was successfully created.' }
        format.json { render json: @documento, status: :created, location: @documento }
      else
        format.html { render action: "new" }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documenti/1
  # PUT /documenti/1.json
  def update
    @documento = Documento.find(params[:id])

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

  # DELETE /documenti/1
  # DELETE /documenti/1.json
  def destroy
    @documento = Documento.find(params[:id])
    @documento.destroy

    respond_to do |format|
      format.html { redirect_to documenti_url }
      format.json { head :no_content }
    end
  end
end
