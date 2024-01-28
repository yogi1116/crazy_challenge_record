module ColorHelper
  def color_classes_for_rank(rank)
    bg_color, tag_bg_color, border_color, text_color = case rank
                                          when 1
                                            ['bg-yellow-500', 'bg-yellow-700', 'border-yellow-900', 'text-white']
                                          when 2
                                            ['bg-slate-300', 'bg-slate-700', 'border-slate-900', 'text-white']
                                          when 3
                                            ['bg-orange-500', 'bg-orange-700', 'border-orange-900', 'text-white']
                                          else
                                            ['bg-white', 'bg-white',  'border-black', 'text-black']
                                          end
  end
end