class Task < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :category
  has_many :task_images
  accepts_nested_attributes_for :task_images, allow_destroy: true
  validates :category_id, presence: true
end
