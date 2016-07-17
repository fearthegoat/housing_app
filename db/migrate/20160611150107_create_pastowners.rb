class CreatePastowners < ActiveRecord::Migration
  def change
    create_table :pastowners do |t|
      t.references :owner, index: true
      t.references :house, index: true

      t.timestamps null: false
    end
  end
end