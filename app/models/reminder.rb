class Reminder < ActiveRecord::Base
	belongs_to :memory
	belongs_to :time_unit
end
