class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :auth_token
      t.string :salt
      t.timestamps
    end
    add_index :users, :auth_token, unique: true
    add_index :users, :salt, unique: true
  end
end
