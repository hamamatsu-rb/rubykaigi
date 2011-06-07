class AddOmniauthAttributesToRubyists < ActiveRecord::Migration
  def self.up
    add_column :rubyists, :provider, :string
    add_column :rubyists, :uid, :string
  end

  def self.down
    remove_column :rubyists, :provider
    remove_column :rubyists, :uid
  end
end
