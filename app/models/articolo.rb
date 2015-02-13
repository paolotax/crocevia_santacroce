require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Articolo < ActiveRecord::Base
  
  
  belongs_to :cliente
  belongs_to :documento
  belongs_to :categoria

  has_many :movimenti, dependent: :destroy
  has_many :photos,    dependent: :destroy
  
  
  validates :nome,        presence: true
  
  validates :quantita,    presence: true
  validates :prezzo,      presence: true
  validates :categoria,   presence: true

  # include HasBarcode
  # 
  # has_barcode :barcode,
  #   :outputter => :svg, 
  #   :type => :code_39,
  #   :value => Proc.new { |p| p.number }
  # 
  # def number
  #   self.id.to_s
  # end
  
  
  attr_accessible :nome, :prezzo, :provvigione, :quantita, :cliente_id, :documento_id, :categoria_id, :index, :eli
  

  delegate :patate, :scadenza, to: :categoria


  after_create  :to_barby
  before_save   :update_index

  before_save :calc_provvigione
  def calc_provvigione
    self.provvigione = self.categoria.provvigione
  end
  
  after_save    :update_documento
  after_destroy :decrement_documento,
                :remove_barcode
    
  
  scope :eli,         where("articoli.eli = ?", true)
  scope :non_eli,     where("articoli.eli is null or articoli.eli = ?", false)
  
  scope :disponibili, where("articoli.quantita > articoli.movimenti_count")
  scope :esauriti,    where("articoli.quantita = articoli.movimenti_count")
  scope :esagerati,   where("articoli.quantita < articoli.movimenti_count")
  scope :attivo,      where("articoli.documento_id is null")
  scope :registrato,  where("articoli.documento_id is not null")
  
  scope :trova, lambda { |term| 
    where("(articoli.nome ilike :term) or (articoli.id = :id) ", term: term, id: term.to_i)        
  }
  
  def to_barby
    barcode_value = self.id.to_s
    barcode = Barby::Code39.new(barcode_value)
    full_path = "#{Rails.root}/public/barcodes/barcode_#{barcode_value}.png"
    File.open(full_path, 'w') { |f| f.write barcode.to_png(:margin => 0, :xdim => 2, :height => 30) }
  end


  def self.scaduti
    Articolo.includes(:documento, :categoria).disponibili.select{ |a| a.scaduto? == true}
  end

  def self.patate
    Articolo.includes(:documento, :categoria).disponibili.select{ |a| a.patate? == true}
  end

  def attivo?
    documento_id.nil?
  end
  
  def disponibile?
    quantita > movimenti_count
  end
  
  def eli?
    eli == true
  end
  
  def data_carico
    try(:documento).try(:data) || created_at.to_date
  end
  
  def data_scadenza
    start_date = Date.new(data_carico.year, 6, 1)
    end_date = Date.new(data_carico.year, 7, 31)
    
    if (start_date..end_date).cover?(data_carico) == true
      data_carico + (scadenza + 30).days
    else
      data_carico + scadenza.days
    end
  end
  
  def data_patate
    start_date = Date.new(data_carico.year, 6, 1)
    end_date = Date.new(data_carico.year, 7, 31)
    if (start_date..end_date).cover?(data_carico) == true
      data_carico + (patate + 30).days
    else
      data_carico + patate.days
    end
  end
  
  def giorni_di_giacenza
    (Time.now.to_date - data_carico).to_i
  end

  def scaduto?
    Time.now > data_scadenza && Time.now < data_patate
  end
  
  def patate?
    Time.now > data_patate
  end  
  
  def giacenza
    quantita - movimenti_count
  end
  
  def valore_giacenza
    prezzo_vendita * giacenza
  end

  def prezzo_vendita
    if scaduto? || patate?
      prezzo / 2
    else
      prezzo
    end
  end
  
  def importo
    prezzo * giacenza
  end
  
  def importo_provvigione
    prezzo * categoria.provvigione * giacenza / 100
  end
  
  def ricavo
    importo - importo_provvigione
  end
  

  def self.ricalcola_counter
    Articolo.find_each do |p|
      Articolo.update_counters p.id, :movimenti_count => p.movimenti.length
    end
  end 

  def self.ricalcola_eli
    Movimento.find_each do |m|
      if m.patate?
        m.articolo.eli = true
        m.articolo.save
      end
    end
    Articolo.disponibili.non_eli.find_each do |a|
      if a.patate?
        a.eli = true
        a.save
      end
    end
  end  
  
  private
    
    def update_index
      self.index = "#{id} #{nome}"
    end
    
    def update_documento
      return true unless prezzo_changed? || quantita_changed? || documento_id_changed?
      unless documento.nil?
        if prezzo_changed? || quantita_changed?
          Documento.update_counters documento.id, 
            :importo   => importo - ((prezzo_was * quantita_was) || 0.0)
        else
          Documento.update_counters documento.id, 
            :importo   => importo
        end    
      end
      return true
    end
    
    def decrement_documento      
      unless documento.nil?
        Documento.update_counters documento.id, 
        :importo   => - prezzo_was * quantita_was
      end  
      return true
    end
    
    def remove_barcode
      FileUtils.remove_file("#{Rails.root}/public/barcodes/barcode_#{id}.png", :force => true)
    end

end
