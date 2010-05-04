class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :vk_sid
      t.integer :vk_mid
      t.string :vk_secret
      t.datetime :vk_expire
      t.string :vk_username
      t.string :twitter_handle
      t.string :twitter_username
      t.string :twitter_token
      t.string :twitter_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
