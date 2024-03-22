# [サービス名：CRAZY MAN]
[![Image from Gyazo](https://i.gyazo.com/6c8fd350656c44d89adb2c5e66206b8c.png)](https://gyazo.com/6c8fd350656c44d89adb2c5e66206b8c)

## サービス概要
クレイジーな挑戦に挑んだ人々の、その挑戦記について投稿共有できるサービスです。  
様々な挑戦に挑む人々を応援し、投稿を見た人々に挑戦する勇気を与えられたらいいなと思っています！  

## サービスのURL
<https://fierce-plateau-48229-09e6d0eb36ec.herokuapp.com/posts>  

## サービスコンセプト
私は大学時代、好奇心から人がやらないような挑戦をした経験があります。  
その際、日常では味わえない経験や予想だにしない展開が起こったりなど、とても記憶に残ることばかりでした。  
そういった経験から、変わった挑戦をするとその人にしか分からない貴重な経験談を秘めているのではないかと思いました。  
それがきっかけで、様々な挑戦をした人々のその体験談を知りたいと思うようになり、「CRAZY MAN」を作成しました。  
このアプリでは、挑戦する人々を応援し、アプリを通して少しでも挑戦する勇気につながるそんなアプリでありたいと思っています。  

## 機能一覧
| ログイン機能| プロフィール機能 |
----|----
| [![Image from Gyazo](https://i.gyazo.com/bb3ba6299f4d4f2f7d5bb6f06212a71b.jpg)](https://gyazo.com/bb3ba6299f4d4f2f7d5bb6f06212a71b) | [![Image from Gyazo](https://i.gyazo.com/db64e638a9efde01abc16ef3b768386c.png)](https://gyazo.com/db64e638a9efde01abc16ef3b768386c) |
|ログイン情報の入力|プロフィール情報の入力|

| 投稿機能 | おすすめ挑戦投稿機能 |
----|----
| [![Image from Gyazo](https://i.gyazo.com/339324042cb65ff58317bc509e68c4c3.gif)](https://gyazo.com/339324042cb65ff58317bc509e68c4c3) | [![Image from Gyazo](https://i.gyazo.com/b4efcfc0494d7764f14c3a80151fc94a.gif)](https://gyazo.com/b4efcfc0494d7764f14c3a80151fc94a) |
|COMPLETEまたはGIVE UPから選択し投稿する。危険な内容はAPIで投稿拒否される|おすすめの挑戦内容を記載し投稿する。危険な内容はAPIで投稿拒否される。|

| いいね機能 | ランキング機能 |
----|----
| [![Image from Gyazo](https://i.gyazo.com/6fe10f754391cc67d8aed35e517c1168.gif)](https://gyazo.com/6fe10f754391cc67d8aed35e517c1168) | [![Image from Gyazo](https://i.gyazo.com/f6865693d8cc9b93cd4570afcce8fc2e.png)](https://gyazo.com/f6865693d8cc9b93cd4570afcce8fc2e) |
|COMPLETE・GIVE UP・おすすめチャレンジそれぞれに合ったいいねボタンを作成。|COMPLETEチャレンジに限り、いいね数を基にランキング化。めざせCRAZY MAN！|

| コメント機能 | 検索機能 |
----|----
| [![Image from Gyazo](https://i.gyazo.com/b952ac5be7abcb815bfcce625ce76f31.gif)](https://gyazo.com/b952ac5be7abcb815bfcce625ce76f31) | [![Image from Gyazo](https://i.gyazo.com/c9b9bb5fec8922c527fb1470c9dbf1b6.gif)](https://gyazo.com/c9b9bb5fec8922c527fb1470c9dbf1b6) |
|全ての投稿に対しコメントができる。|挑戦結果・カテゴリーの片方ずつまたは両方から検索可能。|

| チャット機能 | AIから挑戦提案機能 |
----|----
| [![Image from Gyazo](https://i.gyazo.com/6cb832b53afa453088b2ffbdd5270753.png)](https://gyazo.com/6cb832b53afa453088b2ffbdd5270753) | [![Image from Gyazo](https://i.gyazo.com/c074110db5c58402d089ef4eed5804d9.gif)](https://gyazo.com/c074110db5c58402d089ef4eed5804d9) |
|ユーザー同士でチャットができる。|AIに挑戦内容を提案してもらうことができる。|


### 使用技術
| Category | Technology Stack |
| --- | --- |
| サーバーサイド | Ruby on Rails |
| フロントエンド | Ruby on Rails, JavaScript |
| CSSフレームワーク | TailwindCSS |
| Web API | Natural Language API, Open AI API, LINE Developers |
| データベース | PostgreSQL |
| キャッシュ, セッション管理 | redis |
| インフラ | heroku |
| ファイルサーバー | AWS S3 |

### 画面遷移図
https://www.figma.com/file/bYm3gAgfyFwbDCRwKpCDT3/crazy_challenge_record?type=design&node-id=0%3A1&mode=design&t=Y6dHQ2dFwSjpMyqN-1

### ER図
[![Image from Gyazo](https://i.gyazo.com/c7e1ec199c6939334374c49dac61b263.png)](https://gyazo.com/c7e1ec199c6939334374c49dac61b263)