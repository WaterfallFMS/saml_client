class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    redirect_to '/auth/saml' # to test omni-auth-saml
    #redirect_to '/saml' # to test ruby-saml
  end
end
