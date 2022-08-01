class CreateEarnings < ActiveRecord::Migration[6.1]
  def self.up
    create_table :earnings do |t|

      t.date :earning_date
      t.integer :amount  #storing amount in cents
      t.references :employee, null:false, foreign_key:true
      t.timestamps
    end
  end

  def self.down
      drop_table :earnings
  end
end
