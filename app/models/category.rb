class Category < ActiveRecord::Base
  has_one :task
end
