require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Articolo < ActiveRecord::Base
  
  has_many :movimenti
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
  
  belongs_to :cliente
  
  attr_accessible :categoria_id, :cliente_id, :nome, :prezzo, :provvigione, :quantita

  def data_scadenza
    self.created_at + 2.months
  end
  
  def data_patate
    self.created_at + 3.months
  end
  
  def scaduto?
    Time.now > self.data_scadenza && Time.now < self.data_patate
  end
  
  def patate?
    Time.now > self.data_patate
  end  
  
  def prezzo_vendita
    if self.scaduto?
      self.prezzo / 2
    else
      self.prezzo
    end
  end
  
  def importo
    if prezzo
      self.prezzo.to_d * self.quantita
    else
      0
    end
  end
  
  def importo_cliente
    if prezzo
      self.prezzo.to_d * self.provvigione * self.quantita / 100
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
end
