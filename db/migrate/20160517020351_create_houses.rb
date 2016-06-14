class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.integer :number
      t.string :street
      t.string :street_type
      t.integer :zip_code
      t.string :unit
      t.string :owner_first_name
      t.string :owner_last_name
      t.string :map_number
      t.integer :land_area
      t.string :land_use
      t.integer :book
      t.integer :page
      t.integer :sq_ft
      t.integer :year_built
      t.string :style
      t.integer :bedrooms
      t.integer :full_baths
      t.integer :half_baths
      t.integer :fireplaces

      t.timestamps null: false
    end
    add_foreign_key :houses, :map_number, name: :map_number
  end
end
