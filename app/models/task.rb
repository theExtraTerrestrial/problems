class Task < ActiveRecord::Base
  belongs_to :category
  has_many :task_images
  accepts_nested_attributes_for :task_images, allow_destroy: true
end
