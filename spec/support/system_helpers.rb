module SystemHelpers
  def check_categories(*category_values)
    category_values.each do |value|
      find("input[type='checkbox'][value='#{value}']").check
    end
  end

  def upload_images(*file_names)
    file_paths = file_names.map { |file_name| "#{Rails.root}/spec/fixtures/files/#{file_name}" }
    attach_file 'post[images][]', file_paths
  end
end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end