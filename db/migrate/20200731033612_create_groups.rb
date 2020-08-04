class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :otu_user
      t.integer :kou_user

      t.timestamps
    end
  end
end
