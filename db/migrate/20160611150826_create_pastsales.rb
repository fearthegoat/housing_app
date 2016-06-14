class CreatePastsales < ActiveRecord::Migration
  def change
    create_table :pastsales do |t|
      t.references :sale, index: true
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :pastsales, :owners
    add_foreign_key :pastsales, :sales
  end
end
