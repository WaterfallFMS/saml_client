class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token # SAML comes from an external site

  def create
    logger.debug '-'*80
    logger.debug params.inspect
  end

private
  def auth_hash
    request.env['omniauth.auth']
  end
  helper_method :auth_hash
end