class CreateMemories < ActiveRecord::Migration
  def change
    create_table :memories do |t|
      t.integer :user_id
      t.integer :folder_id
      t.string :title
      t.string :subtitle
      t.string :text
      t.string :source
      t.date :start_date

      t.timestamps null: false
    end
  end
end
