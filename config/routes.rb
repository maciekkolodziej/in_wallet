Rails.application.routes.draw do
  get '/api/private/swagger', to: 'swagger#private', as: 'private_swagger'
  get '/api/public/swagger', to: 'swagger#public', as: 'public_swagger'
  mount Api::Root => '/api'
end
