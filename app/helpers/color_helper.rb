module ColorHelper
  def color_classes_for_rank(rank)
    bg_color, tag_bg_color, border_color, text_color = case rank
                                          when 1
                                            ['bg-yellow-500', 'bg-yellow-700', 'border-yellow-700', 'text-yellow-300']
                                          when 2
                                            ['bg-slate-300', 'bg-slate-700', 'border-silver-700', 'text-silver-300']
                                          when 3
                                            ['bg-orange-600', 'bg-orange-700', 'border-bronze-700', 'text-bronze-300']
                                          else
                                            ['bg-white', 'bg-white',  'border-black', 'text-black']
                                          end
  end
end