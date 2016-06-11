class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :street_number
      t.string :street
      t.integer :zip_code
      t.string :state
      t.date :information_date

      t.timestamps null: false
    end
  end
end
