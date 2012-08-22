class Photo < ActiveRecord::Base
  attr_accessible :photo
  
  belongs_to :message
  
  include Rails.application.routes.url_helpers
  mount_uploader :photo, PhotoUploader

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
      {
        "name" => read_attribute(:photo),
        "size" => photo.size,
        "url" => photo.url,
        "thumbnail_url" => photo.thumb.url,
        "delete_url" => photo_path(:id => id),
        "delete_type" => "DELETE" 
      }
  end
end
