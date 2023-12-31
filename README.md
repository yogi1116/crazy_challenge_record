# [サービス名]
CRAZY MAN

## サービス概要
一般人が真似できないようなクレイジーな挑戦に挑んだ人々の、その挑戦談について投稿共有できるサービスです。

## 想定されるユーザー層
クレイジーな挑戦に挑み、その挑戦談を共有したい人  
他人の挑戦談に興味がある人  
変わったことに挑戦してみたい人  
挑戦する勇気をもらいたい人  

## サービスコンセプト
クレイジーな挑戦をした人がいても、その経験を語ったり知る機会は多くありません。  
自分から話すと「自慢話？」「変わった人」などと相手にマイナスな印象を抱かる恐れもあるため、  
だれ彼構わず発信することは難しいものです。  
しかし、そういったクレイジーな物語には、私たちの知らない展開が待っていたり、  
意外な気づきを貰える貴重な経験談だと私は思います。  
そんなクレイジーなお話を、クレイジーな挑戦に興味のある人や、  
人の挑戦を応援したい人に向け発信できるサービスです。  

私は大学時代、好奇心から人がやらないような挑戦をした経験があります。  
自分で挑戦しときながら、とても辛いものばかりでした。  
しかしそれ以上に、達成した時の喜びは言葉で表せないものでした。今でもその当時の記憶は強く残っています。  
それがきっかけで、  
「あの挑戦談を誰かに話したい」  
「クレイジーな挑戦に挑んだ人々の挑戦談をたくさん知りたい」  
と思うようになり、このサービスを考えました。  

投稿内容は、以下のとおりです。  
* まず完遂・断念（マークダウン方式で「完遂」を選択）
* 挑戦名
* 内容
* カテゴリー（マークダウン方式複数選択可）
* 記録（目的達成のタイムなど）
* 印象に残った出来事
* 得られた教訓

ユーザーはその投稿に「いいね」ならぬ「クレイジー」することができます。  
「クレイジー」の目的は、人によってクレイジーの度合いの認識が違うため、  
より多くの「クレイジー」を獲得できた上位10個のエピソードを「真のクレイジー」として  
ランキングで発表します。  
同時に自分の挑戦のクレイジーさを他のユーザーを通して認識してもらうことにもつながります。

また、クレイジーな挑戦には断念がつきものだと思うので、「夢半ば断念した挑戦」も投稿できるようにします。  
投稿内容は以下のとおりです。
* まず完遂・断念（マークダウン方式で「断念」を選択）
* 断念した挑戦名
* 内容
* カテゴリー（マークダウン方式複数選択可）
* 感想
* 得られた教訓
* 再挑戦する、しない（マークダウン方式）

⑥で再挑戦するを選択したら  
ユーザーは、その投稿に「いいね」ならぬ「ファイト」することができます。  
また、ユーザーがその挑戦を危険と感じたら「やめて」することもできます。    
投稿者は「ファイト」数で、諦めかけたその挑戦の再始動や「やめて」数で身の危険などを  
認識してもらうことにつなげる目的のため、ランキング化はしません。  
⑥で再挑戦しないを選択したら  
ユーザーはその投稿に「いいね」ならぬ「おつかれ」することができます。こちらもランキング化しません。

本サービスの差別化
* 挑戦だけに特化
* 「いいね」ならぬ「クレイジー」「ファイト」「やめて」「おつかれ」などオリジナルのリアクションの導入
* なかでもクレイジーな挑戦を決定するためのランキングの導入
* チャット機能で、その挑戦に興味を持った人やクレイジー同士でつながる機会の導入
* クレイジーな挑戦に興味を抱き、挑戦したいが「何に挑戦すればいいのか？」と考えるユーザーにクレイジーな挑戦の提案する　　
* またユーザーが考えたクレイジーな挑戦を投稿することも可能

## 実装を予定している機能
### MVP
未登録ユーザー
* 会員登録
* ログイン
* 投稿一覧
* 投稿詳細
登録ユーザー
* パスワードリセット機能
* プロフィール機能（未登録ユーザー閲覧可能）
* いいね機能
* コメント
* 投稿
* 画像アップロード機能
* 管理者機能
* 通報機能（公に公表するのに不適切な挑戦内容は削除）
* Natural Language API（投稿に不適切な内容のフィルタリング）

### その後の機能
* カテゴリー検索
* 通知機能（投稿に「いいね機能」「コメント」されたら）
* チャット機能
* ランキング
* open AI（クレイジーな挑戦内容の提案に活用）
* テスト（Rspec）

### 画面遷移図
https://www.figma.com/file/bYm3gAgfyFwbDCRwKpCDT3/crazy_challenge_record?type=design&node-id=0%3A1&mode=design&t=Y6dHQ2dFwSjpMyqN-1

### ER図
https://gyazo.com/65cded7ff801ec9fb3d9b6cf0c5c144d