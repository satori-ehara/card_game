class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :condition
      t.string :deck
      t.integer :field_card
      t.string :turn
      t.string :action
      t.string :turn_count

      t.timestamps
    end
  end
end
