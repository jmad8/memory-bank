class CreateTimeUnits < ActiveRecord::Migration
  def change
    create_table :time_units do |t|
      t.string :unit
    end
  end
end
