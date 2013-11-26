Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
    :issuer                             => "waterfall-saml-client",
    :idp_sso_target_url                 => "https://app.onelogin.com/trust/saml2/http-post/sso/342922",
    :idp_cert_fingerprint               => "96:9E:B2:2E:FE:23:19:69:3B:02:58:16:25:DC:2C:27:F8:27:A1:FC",
    :name_identifier_format             => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
end