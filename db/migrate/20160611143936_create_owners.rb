class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.timestamps null: false
    end
  end
end
