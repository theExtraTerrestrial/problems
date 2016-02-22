class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  belongs_to :role
  has_many :tasks

  def full_name
  	"#{first_name} #{last_name}"
  end
end
