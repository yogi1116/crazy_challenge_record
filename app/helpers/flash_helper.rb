module FlashHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then 'bg-blue-500'
    when :notice then 'bg-green-500'
    when :error then 'bg-red-500'
    else 'bg-gray-500'
    end
  end

  def flash_border_color(type)
    case type.to_sym
    when :success then 'border-blue-500'
    when :notice then 'border-green-500'
    when :error then 'border-red-500'
    else 'border-gray-500'
    end
  end

  def flash_background_thin_color(type)
    case type.to_sym
    when :success then 'bg-blue-100'
    when :notice then 'bg-green-100'
    when :error then 'bg-red-100'
    else 'bg-gray-100'
    end
  end

  def flash_text_color(type)
    case type.to_sym
    when :success then 'text-blue-700'
    when :notice then 'text-green-700'
    when :error then 'text-red-700'
    else 'text-gray-700'
    end
  end
end
