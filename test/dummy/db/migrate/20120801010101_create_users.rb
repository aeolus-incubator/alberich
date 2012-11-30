class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,               :null => false
      t.string :email
      t.string :crypted_password
      t.string :first_name
      t.string :last_name
      t.integer :login_count,            :null => false, :default => 0
      t.integer :failed_login_count,     :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip

      t.timestamps
    end
  end
end
