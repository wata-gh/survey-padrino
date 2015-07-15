class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :surveys_id
      t.string :text
      t.integer :type
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
