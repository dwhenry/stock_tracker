module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def current_user
    Current.session&.user
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You don't have permission to access that page."
    end
  end
end
