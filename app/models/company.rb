class Company < ActiveRecord::Base
	has_many :admin_users
	has_many :tasks
end
