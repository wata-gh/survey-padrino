class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :surveys_id
      t.string :uuid, :limit => 36
      t.integer :no
      t.text :text
      t.timestamps
    end
    add_index :questions, :surveys_id
    add_index :answers, :surveys_id
    add_index :answers, :uuid
  end

  def self.down
    drop_index :questions, :surveys_id
    drop_index :answers, :surveys_id
    drop_index :answers, :uuid
    drop_table :answers
  end
end
