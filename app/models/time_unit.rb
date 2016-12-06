class TimeUnit < ActiveRecord::Base
	has_many :reminders
	validates :unit, presence: true, uniqueness: { case_sensitive: false }
end
