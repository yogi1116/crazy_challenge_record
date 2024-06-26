class BackgroundUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  process :convert_heic_to_jpeg
  process :conditional_resize

  def convert_heic_to_jpeg
    if file.extension.downcase == 'heic'
      cache_stored_file! if !cached?
      image = MiniMagick::Image.open(current_path)
      image.format('jpg')
      image.write(current_path)
    end
  end

  def conditional_resize
    image = MiniMagick::Image.open(file.path)
    return if image[:width] <= 2000 && image[:height] <= 500

    resize_to_fit(2000, 500)
  end

  # Choose what kind of storage to use for this uploader:
  # storage :fog
  if Rails.env.production?
    storage :aws
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'background_image.svg'
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg"
  # end
end
