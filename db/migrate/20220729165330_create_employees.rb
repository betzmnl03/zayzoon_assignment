class CreateEmployees < ActiveRecord::Migration[6.1]
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :external_ref, null:false
      t.references :employer, null:false, foreign_key:true
      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
