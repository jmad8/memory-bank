class Memory < ActiveRecord::Base
	belongs_to :user
	belongs_to :folder
	has_many :memory_days, dependent: :destroy
	has_many :reminders, dependent: :destroy
	accepts_nested_attributes_for :reminders

	validates :title,  presence: true
	validates :text,  presence: true
	validates :start_date, presence: true

	before_save :prepare_data
	after_save :set_reminders

	def prepare_data
		self.reminders.each_with_index do |reminder, index|
			reminder.priority = index + 1
		end
		Reminder.where(memory_id: self.id).delete_all
		MemoryDay.where(memory_id: self.id).delete_all
	end

	def set_reminders
		tempDate = self.start_date
		MemoryDay.new({memory_id: self.id, day: tempDate}).save
		self.reminders.each_with_index do |reminder, index|
			loop_amount = reminder.repeat_quantity
			loop_amount -= 1 if reminder.priority == 1
			loop_amount.times do
				case reminder.time_unit_id
				when 1 # days
					tempDate = tempDate + reminder.time_unit_quantity.days
					MemoryDay.new(memory_id: self.id, day: tempDate).save
				when 2 # weeks
					tempDate = tempDate + reminder.time_unit_quantity.weeks
					MemoryDay.new(memory_id: self.id, day: tempDate).save
				when 3 # months
					tempDate = tempDate + reminder.time_unit_quantity.months
					MemoryDay.new(memory_id: self.id, day: tempDate).save
				when 4 # years
					tempDate = tempDate + reminder.time_unit_quantity.years
					MemoryDay.new(memory_id: self.id, day: tempDate).save
				end
			end
		end
	end
end
