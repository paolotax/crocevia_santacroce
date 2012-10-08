require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Articolo < ActiveRecord::Base
  
  belongs_to :cliente
  belongs_to :documento
  
  has_many :movimenti, dependent: :destroy
  
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
  
  after_save :to_barby
  
  def to_barby
    barcode_value = self.id.to_s
    barcode = Barby::Code39.new(barcode_value)
    full_path = "public/barcodes/barcode_#{barcode_value}.png"
    File.open(full_path, 'w') { |f| f.write barcode.to_png(:margin => 0, :xdim => 2, :height => 30) }
  end
  
  def giacenza
    self.quantita - self.movimenti_count
  end
  
  def valore_giacenza
    self.prezzo_vendita * self.giacenza
  end
  
  attr_accessible :nome, :prezzo, :provvigione, :quantita, :cliente_id, :documento_id, :index
  
  scope :disponibili, where("articoli.quantita > articoli.movimenti_count")
  scope :esauriti,    where("articoli.quantita = articoli.movimenti_count")
  scope :esagerati,   where("articoli.quantita < articoli.movimenti_count")
  scope :attivo,      where("articoli.documento_id is null")
  scope :registrato,  where("articoli.documento_id is not null")
  
  
  scope :trova, lambda { |term| 
    where("(articoli.nome ilike :term) or (articoli.id = :id) ", term: term, id: term.to_i)        
  }

  def attivo?
    documento_id.nil?
  end
  
  def disponibile?
    quantita > movimenti_count
  end
  
  def data_scadenza
    created_at + 2.months
  end
  
  def data_patate
    created_at + 3.months
  end
  
  def scaduto?
    Time.now > data_scadenza
  end
  
  def patate?
    Time.now > data_patate
  end  
  
  def prezzo_vendita
    if scaduto?
      prezzo / 2
    else
      prezzo
    end
  end
  
  def importo
    if prezzo
      prezzo.to_d * quantita
    else
      0
    end
  end
  
  def importo_cliente
    if prezzo
      prezzo.to_d * provvigione * quantita / 100
    else
      0
    end  
  end
    
  def prezzo_in_euro
    prezzo.to_d/100 if prezzo
  end
  
  def prezzo_in_euro=(euros)
    self.prezzo = euros.to_d if euros.present?
  end
  
  def self.ricalcola_counter
    Articolo.find_each do |p|
      Articolo.update_counters p.id, :movimenti_count => p.movimenti.length
    end
  end  
  
  before_save :update_index
  
  private
    
    def update_index
      self.index = "#{id} #{nome}"
    end
    
    
end
