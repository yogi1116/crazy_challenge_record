# [サービス名：CRAZY MAN]
[![Image from Gyazo](https://i.gyazo.com/6c8fd350656c44d89adb2c5e66206b8c.png)](https://gyazo.com/6c8fd350656c44d89adb2c5e66206b8c)

## サービス概要
クレイジーな挑戦に挑んだ人々の、その挑戦記について投稿共有できるサービスです。  
様々な挑戦に挑む人々を応援し、投稿を見た人々に挑戦する勇気を与えられたらいいなと思っています！  

## サービスのURL
<https://fierce-plateau-48229-09e6d0eb36ec.herokuapp.com/>  

## サービスコンセプト
私は大学時代、好奇心から人がやらないような挑戦をした経験があります。  
その際、日常では味わえない経験や予想だにしない展開が起こったりなど、とても記憶に残ることばかりでした。  
そういった経験から、変わった挑戦をするとその人にしか分からない貴重な経験談を秘めているのではないかと思いました。  
それがきっかけで、様々な挑戦をした人々のその体験談を知りたいと思うようになり、「CRAZY MAN」を作成しました。  
このアプリでは、挑戦する人々を応援し、アプリを通して少しでも挑戦する勇気につながるそんなアプリでありたいと思っています。  

## 機能一覧
| ログイン機能| プロフィール機能 |
----|----
| <a href="https://gyazo.com/e7fc26f81873de37eba835c27e4dd135"><img src="https://i.gyazo.com/e7fc26f81873de37eba835c27e4dd135.jpg" alt="Image from Gyazo" width="400"/></a> | <a href="https://gyazo.com/32a9fd348cb63153a78001bd83a45513"><img src="https://i.gyazo.com/32a9fd348cb63153a78001bd83a45513.png" alt="Image from Gyazo" width="400"/></a> |
|ログイン情報の入力|プロフィール情報の入力|

| 投稿機能 | おすすめ挑戦投稿機能 |
----|----
| <a href="https://gyazo.com/16e0da93b2ae48fe531101f2c68efb38"><img src="https://i.gyazo.com/16e0da93b2ae48fe531101f2c68efb38.jpg" alt="Image from Gyazo" width="400"/></a> | <a href="https://gyazo.com/1ec2830e1c197b885b47668e35bc6ea2"><img src="https://i.gyazo.com/1ec2830e1c197b885b47668e35bc6ea2.jpg" alt="Image from Gyazo" width="400"/></a> |
|COMPLETEまたはGIVE UPから選択し投稿する。|おすすめの挑戦内容を記載し投稿する。|

| いいね機能 | ランキング機能 |
----|----
| <a href="https://gyazo.com/e7c8d9ef81b5ca9ab6cbf2dc7d55e268"><img src="https://i.gyazo.com/e7c8d9ef81b5ca9ab6cbf2dc7d55e268.png" alt="Image from Gyazo" width="400"/></a> | <a href="https://gyazo.com/fd8344fcd34b666447b6c61289085298"><img src="https://i.gyazo.com/fd8344fcd34b666447b6c61289085298.png" alt="Image from Gyazo" width="400"/></a> |
|4種類のいいねボタンがあります。|COMPLETEチャレンジに限りランキング化。|

| コメント機能 | 検索機能 |
----|----
| <a href="https://gyazo.com/96a11b7febf10cf31196c6840a354709"><img src="https://i.gyazo.com/96a11b7febf10cf31196c6840a354709.jpg" alt="Image from Gyazo" width="400"/></a> | <a href="https://gyazo.com/41c6bfd488196607d2ca4eea4bfceeb5"><img src="https://i.gyazo.com/41c6bfd488196607d2ca4eea4bfceeb5.jpg" alt="Image from Gyazo" width="400"/></a> |
|全ての投稿に対しコメントができる。|挑戦結果・カテゴリーから検索可能。|

| チャット機能 | AIから挑戦提案機能 |
----|----
| <a href="https://gyazo.com/b2f37f710f6d1cf15f3a02c8d0091bb2"><img src="https://i.gyazo.com/b2f37f710f6d1cf15f3a02c8d0091bb2.png" alt="Image from Gyazo" width="400"/></a> | <a href="https://gyazo.com/560fec0959d3f97260309674440579b0"><img src="https://i.gyazo.com/560fec0959d3f97260309674440579b0.png" alt="Image from Gyazo" width="400"/></a> |
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