class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :entire_address
      t.integer :street_number
      t.string :street
      t.string :unit
      t.integer :zip_code
      t.string :state
      t.timestamps null: false
    end
  end
end
