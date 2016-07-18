class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.references :house, index: true
      t.integer :year
      t.integer :land
      t.integer :building
      t.integer :assessed_total
      t.string :tax_exempt?
      t.timestamps null: false
      t.string
    end
  end
end
