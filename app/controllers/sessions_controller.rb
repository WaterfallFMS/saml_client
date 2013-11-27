class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token # SAML comes from an external site

  def create
    logger.debug '-'*80
    logger.debug params.inspect
  end

  def failure
    logger.debug '-'*80
    logger.debug 'auth-failure'
    logger.debug params.inspect
    logger.debug request.env.inspect
  end
  
  def metadata
    settings = Onelogin::Saml::Settings.new({
      :issuer                             => ENV['SAML_IDP_ISSUER'],
      :idp_sso_target_url                 => ENV['SAML_IDP_TARGET_URL'],
      :idp_cert_fingerprint               => ENV['SAML_IDP_CERT_FINGERPRINT'],
      :name_identifier_format             => ENV['SAML_IDP_NAME_FORMAT']
    })
    meta = Onelogin::Saml::Metadata.new
    render :xml => meta.generate(settings)
  end

private
  def auth_hash
    request.env['omniauth.auth']
  end
  helper_method :auth_hash
end