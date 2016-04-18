class Category < ActiveRecord::Base
  has_many :tasks
  belongs_to :admin_user
end
