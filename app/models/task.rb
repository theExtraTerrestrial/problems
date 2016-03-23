class Task < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :category
  belongs_to :company
  has_many :task_images
  has_many :task_logs
  has_many :task_emails
  accepts_nested_attributes_for :task_images, allow_destroy: true
  accepts_nested_attributes_for :task_logs, allow_destroy: true
  accepts_nested_attributes_for :task_emails, allow_destroy: true
  validates :category_id, presence: true
  validates :name, presence: true
  validates :employee_deadline, presence: true
  has_paper_trail ignore: [:updated_at, :created_at]

  after_create :notify_admin

  scope :recent, ->(num) {order(created_at: :desc).limit(num)}

  PRIORITY = {"zema" => 1, "vidēja" => 2, "augsta" => 3, "ļoti augsta" => 4}
  STATUS = {"pievienots" => 1, "procesā" => 2, "atcelts" => 3, "pabeigts" => 4}

  def notify_admin
    Emailer.notification(self).deliver
  end

end
