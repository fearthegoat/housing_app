class CreatePastaddresses < ActiveRecord::Migration
  def change
    create_table :pastaddresses do |t|
      t.date :date_of_information
      t.references :address, index: true
      t.references :owner, index: true
      t.timestamps null: false
    end
  end
end
