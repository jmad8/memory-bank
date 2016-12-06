class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.integer :user_id
      t.integer :parent_folder_id
      t.string :name
      t.string :description
      t.boolean :published
      t.integer :download_count

      t.timestamps null: false
    end
  end
end
