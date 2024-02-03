module ImageProcessingConcern
  extend ActiveSupport::Concern

  def process_image(image, width: 800, height: 800)
    return unless image

    if image.content_type == 'image/heic'
      processed_image = ::ImageProcessing::Vips
                          .source(image.tempfile)
                          .convert('jpg') # HEICをJPEGに変換
                          .resize_to_limit(width, height)
                          .saver(quality: 80)
                          .call
    else
      processed_image = ::ImageProcessing::Vips
                          .source(image.tempfile)
                          .resize_to_limit(width, height)
                          .saver(quality: 80)
                          .call
    end

    { io: File.open(processed_image.path), filename: "#{File.basename(image.original_filename, '.*')}.jpg", content_type: 'image/jpeg' }
  end
end