class TaskImage < ActiveRecord::Base
  belongs_to :task
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: ["image/jpeg", "image/gif", "image/png", "image/ico"]
end
