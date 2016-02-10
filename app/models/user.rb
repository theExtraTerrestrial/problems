class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :role
  has_many :tasks
end
