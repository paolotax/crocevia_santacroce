class Photo < ActiveRecord::Base
  
  mount_uploader :photo, PhotoUploader
  
  attr_accessible :photo, :crop_x, :crop_y, :crop_w, :crop_h, :rotate, :articolo_id
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :rotate
  after_update :elaborate_photo #:crop_photo

  belongs_to :articolo

  def default_name
    File.basename(photo_url, '.*') if photo
  end

  def name
    try(:articolo).try(:nome) || default_name
  end

  private
  
    def crop_photo
      photo.recreate_versions! if crop_x.present?
    end
  
    def elaborate_photo

      unless crop_x.present? || rotate.present?
        return
      end  

      current_path = self.photo.path
      tmp_name = current_path.sub(/(\.[a-z]+)$/i, '_tmp\1')
      vips = VIPS::Image.new(current_path)
      
      if crop_x.present?
        if vips.y_size > vips.x_size        
          ratio = vips.y_size.to_f / 650
        else
          ratio = vips.x_size.to_f / 650
        end  
        x = crop_x.to_i * ratio
        y = crop_y.to_i * ratio
        w = crop_w.to_i * ratio
        h = crop_h.to_i * ratio
        vips = vips.extract_area(x, y, w, h)
      end  
      
      vips = vips.rot90.write(tmp_name) if rotate.present?
      
      vips.write(tmp_name)
      FileUtils.mv(tmp_name, current_path)

      photo.recreate_versions!
    end  
    
    def get_ratio(image, width, height, min_or_max = :min)
      width_ratio = width.to_f / image.x_size
      height_ratio = height.to_f / image.y_size
      [width_ratio, height_ratio].send(min_or_max)
    end
  
  
end
