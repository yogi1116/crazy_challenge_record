module ImageProcessingConcern
  extend ActiveSupport::Concern

  def process_image(image, width: 800, height: 800)
    return unless image

    processed_image = ::ImageProcessing::Vips
                        .source(image.tempfile)
                        .resize_to_limit(width, height)
                        .saver(quality: 80)
                        .call

    { io: File.open(processed_image.path), filename: image.original_filename, content_type: image.content_type }
  end
end