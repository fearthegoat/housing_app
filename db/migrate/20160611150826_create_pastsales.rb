class CreatePastsales < ActiveRecord::Migration
  def change
    create_table :pastsales do |t|
      t.references :sale, index: true
      t.references :owner, index: true
      t.string :transaction_side
      t.timestamps null: false
    end
  end
end
