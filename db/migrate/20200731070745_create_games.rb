class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :condition
      t.text :deck
      t.integer :field_card
      t.string :turn
      t.string :action
      t.integer :turn_count
      t.integer :group_id
      t.string :one_used
      t.string :message

      t.timestamps
    end
  end
end
