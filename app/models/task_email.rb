class TaskEmail < ActiveRecord::Base
	belongs_to :task

	after_create :send_message

	def send_message
	end
end
