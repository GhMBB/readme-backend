require "cloudinary"
class CloudinaryService
    def self.guardar_archivo(contenido)
      begin
        cloudinary_response = Cloudinary::Uploader.upload(contenido ,resource_type: :auto, folder: "capitulos",api_secret:"LRDlCyJxSBI03yiQzOGQZpBdrvA")
       return cloudinary_response['public_id']
     rescue CloudinaryException => e
      puts e
       return ""
     end
    end
end
