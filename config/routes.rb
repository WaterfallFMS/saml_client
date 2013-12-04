SamlClient::Application.routes.draw do
  # for omniauth testing
  get  '/auth/failure'       => 'sessions#failure'
  get  '/auth/saml/metadata' => 'sessions#metadata'
  post '/auth/saml/callback' => 'sessions#create'

  # for direct Saml testing
  get 'saml' => 'saml#index'
  match 'saml/:action', :controller => 'saml', via: [:get, :post], as: 'saml_action'

  root 'application#index'
end
