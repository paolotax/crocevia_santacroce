class Documento < ActiveRecord::Base
  
  attr_accessible :importo, :tipo, :data_text, :data
  attr_writer :data_text
  
  has_many :articoli,  dependent:  :nullify
  has_many :movimenti, dependent:  :nullify
  has_many :clienti, through: :articoli
  has_many :rimborsi, class_name: "Movimento", foreign_key: :rimborso_id, dependent: :nullify
  
  scope :recente, order("documenti.id desc")
  scope :settimana,  where("data >= ?", Time.now.beginning_of_week )
  # scope :mese where("data >= ?", Time.now.beginning_of_month )
  
  validates :data_text, presence: true 
  validates :tipo,      presence: true 
  
  validate    :check_data_text

  before_save  :save_data_text
  after_create :notify_vendita
  
  TIPO_DOCUMENTO = %w(cassa resa carico rimborso)
  
  TIPO_DOCUMENTO.each do |tipo|
    scope "#{tipo.split.join.underscore}", where("documenti.tipo = ?", tipo)  
    
    define_method "#{tipo.split.join.underscore}?" do
      self.tipo == tipo
    end
  end
  
  def data_text
    @data_text || data.try(:strftime, "%d-%m-%Y")
  end
  
  def mandante
    if tipo == 'carico'
      clienti.uniq.first
    elsif tipo == "resa"
      movimenti.first.cliente
    elsif tipo == 'rimborso'
      rimborsi.try(:first).try(:cliente) || nil
    else
      return nil
    end
  end
  
  def righe
    case tipo
    when "cassa"
      movimenti.order(:articolo_id)
    when "resa"
      movimenti.order(:articolo_id)
    when "carico"
      articoli.order(:id)
    when "rimborso"
      rimborsi.order(:articolo_id)
    end    
  end
  
  def numero_articoli
    articoli.sum(&:quantita)
  end
  
  def importo_carico
    articoli.sum { |a| a.prezzo * a.quantita }
  end
  
  def realizzo
    articoli.sum { |a| a.prezzo * a.quantita * a.provvigione / 100 }.round(2)
  end
  
  def provvigione
    importo_carico - realizzo
  end
        
  def add_movimenti_attivi(user)
    for m in user.movimenti.vendita.attivo do
      self.movimenti << m
    end  
  end
  
  def add_articoli_cliente(cliente_id)
    cliente = Cliente.find(cliente_id)
    for a in cliente.articoli.attivo do
      self.articoli << a
    end  
  end
  
  def add_resa_cliente(cliente_id)
    cliente = Cliente.find(cliente_id)
    for m in cliente.rese.attivo do
      self.movimenti << m
    end  
  end

  def add_rimborso_cliente(cliente_id)
    cliente = Cliente.find(cliente_id)
    for r in cliente.vendite do
      self.rimborsi << r if r.da_rimborsare?
    end  
  end

  def self.filtra(params)
    documenti = scoped
    documenti = documenti.where("documenti.data = ?", Date.new( params[:year].to_i, params[:month].to_i, params[:day].to_i)) if params[:day].present?
    documenti
  end

  
  private
    
    def notify_vendita
      if cassa?
        vendita = self.reload
        Notifier.vendita_added(vendita).deliver
      end  
    end
    
    def save_data_text
      self.data = Date.parse(@data_text) if @data_text.present?
    end

    def check_data_text
      if @data_text.present? && Date.parse(@data_text).nil?
        errors.add :data_text, "formato data errato"
      end
    rescue ArgumentError
      errors.add :data_text, "data non valida"
    end
end
