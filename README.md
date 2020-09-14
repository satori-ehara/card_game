# 名前募集中

# どんな事ができるのか

## アナログカードゲーム「Xeno」をネット上の友人とプレイできるアプリ

# 使用方法
## 🌐 App URL

### **https://cupramen-timer.firebaseapp.com**  

## 手順① 登録、またはログイン

<img width="1440" alt="スクリーンショット 2020-09-14 11 41 37" src="https://user-images.githubusercontent.com/67570383/93038191-4826c000-f67f-11ea-83be-c8f4d5a5fecb.png">

新規登録の場合は、ホーム画面右上にある新規登録ボタンを、
すでにアカウントをお持ちの場合は、ログインボタンを押してください。

移行先で、登録するニックネーム（登録してあるニックネーム）とパスワードを入力していただければ、登録完了となります。

## 手順② 部屋作成

新しい対戦相手とゲームを始める場合、もしくは初めての対戦の場合は、部屋を作成する必要があります。

ホーム画面左上の部屋作成ボタンを押してください。
すると以下の画面に移行します。

<img width="1440" alt="スクリーンショット 2020-09-14 11 38 37" src="https://user-images.githubusercontent.com/67570383/93038111-131a6d80-f67f-11ea-8055-f5a0045e4c30.png">

こちらにて上から、部屋名そして対戦相手を選択してください。
ここでは、部屋を作成した時にログインしていたアカウント vs 選択したアカウント の部屋が作成されます。
部屋を作成した人が必ず先攻になるので、注意してください。

## 手順③ ゲーム開始

作成した部屋をクリックして以下のようなゲーム部屋へ移行してください。

<img width="1438" alt="スクリーンショット 2020-09-14 11 43 22" src="https://user-images.githubusercontent.com/67570383/93038579-59bc9780-f680-11ea-8b1f-65419c2a3cfa.png">

対戦をする二人が揃ったら、左上にあります対戦開始ボタンを押してください。
ゲームが進行します。
ゲームのルールに関しては以下にまとめてあります。（アナログボードゲームの"Xeno"のルールとほぼ同じです。）

# ゲームのルール


# 作成背景



# データベース設計

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|password|string|null: false|
### Association
- has_many :kou
- has_many :otu

## gamesテーブル
|Column|Type|Options|
|------|----|-------|
|condition|string|null: false|
|deck|text|null: false|
|field_card|string|null: false|
|turn|string|null: false|
|turn_count|integer|null: false|
|action|string|null: false|
### Association
- belongs_to :group
- belongs_to :kou
- belongs_to :otu

## kousテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|game_id|integer|null: false, foreign_key: true|
|hand|integer|null: false|
### Association
- belongs_to :user
- belongs_to :game

## otusテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|game_id|integer|null: false, foreign_key: true|
|hand|integer|null: false|
### Association
- belongs_to :user
- belongs_to :game

## groupsテーブル
|Column|Type|Options|
|------|----|-------|
|kou_id|integer|null: false, foreign_key: true|
|otu_id|integer|null: false, foreign_key: true|
|name|string|null: false|
### Association
- belongs_to :game
