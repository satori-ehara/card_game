class CreateKous < ActiveRecord::Migration[6.0]
  def change
    create_table :kous do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :hand

      t.timestamps
    end
  end
end