module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-sky-300"
    when :notice  then "bg-green-500"
    when :error  then "bg-red-500"
    else "bg-gray-500"
    end
  end
end
