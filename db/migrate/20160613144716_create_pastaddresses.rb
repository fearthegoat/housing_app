class CreatePastaddresses < ActiveRecord::Migration
  def change
    create_table :pastaddresses do |t|
      t.date :information_date
      t.references :address, index: true
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :pastaddresses, :owner
    add_foreign_key :pastaddresses, :address
  end
end
