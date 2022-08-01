class CreateEmployers < ActiveRecord::Migration[6.1]
  def self.up
    create_table :employers do |t|
      t.string :name, null: false
      t.json :formats, null: false
      t.timestamps
    end
  end

  def self.down 
    drop_table :employers
  end
end
