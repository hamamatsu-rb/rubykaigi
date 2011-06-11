class AddIndexesToAuthentications < ActiveRecord::Migration
  def self.up
    add_index :authentications, [:provider, :uid]
    add_index :authentications, [:rubyist_id, :provider]
  end

  def self.down
    remove_index :authentications, :provider
    remove_index :authentications, :rubyist_id
  end
end
