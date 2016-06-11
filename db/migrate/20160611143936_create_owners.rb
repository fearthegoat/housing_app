class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.integer :street_number
      t.string :street
      t.string :unit
      t.integer :zipcode
      t.string :state

      t.timestamps null: false
    end
  end
end
