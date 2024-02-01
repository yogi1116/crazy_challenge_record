categories = ['冒険・探究', 'スポーツ', '学習・プログラミング', '芸術', '趣味', 'ビジネス', '極限・忍耐', '前人未到', '似た挑戦した猛者いる？', 'その他']
categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end
