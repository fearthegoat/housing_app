class CreatePastowners < ActiveRecord::Migration
  def change
    create_table :pastowners do |t|
      t.references :owner, index: true
      t.references :house, index: true

      t.timestamps null: false
    end
    add_foreign_key :pastowners, :owners
    add_foreign_key :pastowners, :houses
  end
end