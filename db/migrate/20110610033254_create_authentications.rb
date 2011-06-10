class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.column :id, :integer, :null => false
      t.column :provider, :string, :null => false
      t.column :uid, :string, :null => false
      t.column :rubyist_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
