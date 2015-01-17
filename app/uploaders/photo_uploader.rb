# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  
  include CarrierWave::Vips if Rails.env.production?
  
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process resize_to_fit: [ 800, 800 ]

  version :large do
    resize_to_fit(800, 800) if Rails.env.production?
  end
  
  version :medium do
    resize_to_fit(650, 650) if Rails.env.production?
  end
    
  version :thumb do
    process :croppa if Rails.env.production?
    resize_to_fill(120, 120) if Rails.env.production?
  end
  
  def croppa
    if model.crop_x.present?
      manipulate! do |image|
        resize_to_limit(800, 800)
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        image = image.extract_area(x, y, w, h)
        image
      end  
    end
  end
    
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:

  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
