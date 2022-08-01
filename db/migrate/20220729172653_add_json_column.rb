class AddJsonColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :employers, :formats, :json
  end
end