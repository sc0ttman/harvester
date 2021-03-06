class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
