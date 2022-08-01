class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|

      t.string :name
      t.string :external_ref
      t.references :employer, null:false, foreign_key:true
      t.timestamps
    end
  end
end
