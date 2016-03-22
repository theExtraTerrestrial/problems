class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  def access_denied(exception)
    redirect_to root_path, :alert => exception.message
  end

  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user.try(:id) : 'Unknown user'
  end

end
