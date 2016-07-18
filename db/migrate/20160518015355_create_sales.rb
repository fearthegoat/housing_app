class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.date :date
      t.float :amount
      t.references :house, index: true
      t.timestamps null: false
    end
  end
end
