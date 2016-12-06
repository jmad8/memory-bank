class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :memory_id
      t.integer :priority
      t.integer :time_unit_id
      t.integer :time_unit_quantity
      t.integer :repeat_quantity

      t.timestamps null: false
    end
  end
end
