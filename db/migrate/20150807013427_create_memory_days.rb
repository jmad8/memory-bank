class CreateMemoryDays < ActiveRecord::Migration
  def change
    create_table :memory_days do |t|
      t.integer :memory_id
      t.date :day

      t.timestamps null: false
    end
  end
end
