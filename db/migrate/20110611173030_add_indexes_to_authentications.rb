class AddIndexesToAuthentications < ActiveRecord::Migration
  def self.up
    add_index :authentications, :provider
    add_index :authentications, [:provider, :uid]
  end

  def self.down
    remove_index :authentications, :provider
  end
end
