class CreateOtus < ActiveRecord::Migration[6.0]
  def change
    create_table :otus do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :hand
      t.string :condition

      t.timestamps
    end
  end
end
