class CreatePastsales < ActiveRecord::Migration
  def change
    create_table :pastsales do |t|
      t.references :sale, index: true
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :pastsales, :owner
    add_foreign_key :pastsales, :sale
  end
end
