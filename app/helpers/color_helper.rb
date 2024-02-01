module ColorHelper
  def color_classes_for_rank(rank)
    case rank
    when 1
      %w[bg-yellow-500 bg-yellow-700 border-yellow-900 text-white]
    when 2
      %w[bg-slate-400 bg-slate-700 border-slate-900 text-white]
    when 3
      %w[bg-orange-500 bg-orange-700 border-orange-900 text-white]
    else
      %w[bg-zinc-100 bg-zinc-100 border-black text-black]
    end
  end
end
