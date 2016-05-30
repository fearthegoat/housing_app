class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.date :last_sale
      t.string :map_number
      t.string :owner
      t.integer :street_number
      t.string :street
      t.string :street_type

      t.timestamps null: false
    end
  end
end
