class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :year
      t.integer :land
      t.integer :building
      t.integer :assessed_total
      t.references :house, index: true
      t.timestamps null: false
    end
  end
end
