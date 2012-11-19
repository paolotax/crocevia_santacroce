module CroceviaShared

  def self.rimuovi_barcodes_orfani
    Dir.chdir("#{Rails.root}/public/barcodes/")
    Dir.glob("barcode_*.png").each do |a| 
      id = a[/\d+/].to_i
      unless Articolo.exists?(id)
        FileUtils.remove_file(a)
      end
    end
    Dir.glob("tessera_*.png").each do |c| 
      id = c[/\d+/].to_i
      unless Cliente.exists?(id)
        FileUtils.remove_file(c)
      end
    end  
  end

  def self.aggiungi_barcodes_mancanti
    Articolo.all.each do |a|
      unless File.exists?("#{Rails.root}/public/barcodes/barcode_#{a.id}.png")
        a.to_barby
      end
    end
    Cliente.all.each do |a|
      unless File.exists?("#{Rails.root}/public/barcodes/tessera_#{a.id}.png")
        a.to_barby
      end
    end
  end

end