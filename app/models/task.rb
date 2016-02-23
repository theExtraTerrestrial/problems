class Task < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :category
  has_many :task_images
  accepts_nested_attributes_for :task_images, allow_destroy: true
  validates :category_id, presence: true
  validates :name, presence: true


  scope :recent, ->(num) {order(created_at: :desc).limit(num)}

  PRIORITY = {"zema" => 1, "vidēja" => 2, "augsta" => 3, "ļoti augsta" => 3}
  STATUS = {"pievienots" => 1, "procesā" => 2, "atcelts" => 3, "pabeigts" => 4}
end
