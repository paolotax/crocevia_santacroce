class DocumentiController < ApplicationController

  load_and_authorize_resource
  
  # http://rails-bestpractices.com/posts/47-fetch-current-user-in-models solution
  # violates MVC pattern
  # before_filter :set_current_user

  def index
    @documenti = Documento.recente.filtra(params)
    @paged = @documenti.pagina(params[:page]).per(30)
    @documenti_per_giorno = @paged.group_by_month
  end

  def show

    @righe = @documento.righe

    respond_to do |format|
      format.html
      format.pdf do
        pdf = DocumentoPdf.new(Array(@documento), view_context)
        send_data pdf.render, filename: "#{@documento.tipo}_#{@documento.id}_#{@documento.data.strftime("%Y%m%d")}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def edit
  end

  def create
    @documento = Documento.new(params[:documento])
    
    if params[:documento][:tipo] == 'cassa'
      @documento.add_movimenti_attivi(current_user)
    end

    if params[:documento][:tipo] == 'carico'
      @documento.add_articoli_cliente(params[:cliente_id])
    end

    if params[:documento][:tipo] == 'resa'
      @documento.add_resa_cliente(params[:cliente_id])
    end
    
    if params[:documento][:tipo] == 'rimborso'
      @documento.add_rimborso_cliente(params[:cliente_id])
    end

    respond_to do |format|
      if @documento.save
        format.html { redirect_to @documento, notice: "Documento di #{@documento.tipo} registrato!" }
        format.json { render json: @documento, status: :created, location: @documento }
      else
        format.html { redirect_to :back, error: "Errore nella registrazione!" }
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
    return_url = @documento.mandante || cassa_url
    # non posso passare current_user nel model
    if @documento.cassa?
       @documento.righe.each {|r| r.update_attributes(user: current_user)}
    end
    @documento.destroy
    respond_to do |format|
      format.html { redirect_to return_url }
      format.json { head :no_content }
    end
  end
end
