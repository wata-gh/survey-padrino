class AddFieldToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :is_secret, :boolean, :default => false
    add_column :surveys, :hash_key, :string
  end

  def self.down
    remove_column :surveys, :is_secret
    remove_column :surveys, :hash_key
  end
end
