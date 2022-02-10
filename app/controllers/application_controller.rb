class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_account

  def current_account
    if current_user
      @current_account ||= current_user.account
    else
      @current_account = nil
    end
  end

  def pundit_user
    UserContext.new(current_user, current_account)
  end


  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, { account_attributes: [:nickname] }])
  end
end

class UserContext
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end
end
