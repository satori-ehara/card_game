## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false|
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
|turn_count|integer|null: false, foreign_key: true|
|action|string|null: false, foreign_key: true|
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
