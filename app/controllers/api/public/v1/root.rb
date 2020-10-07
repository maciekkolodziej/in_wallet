module Api::Public::V1
  class Root < Grape::API
    format :json
    prefix "public/v1"

    mount Health
    mount Transactions

    if Rails.env.development? || Rails.env.staging?
      add_swagger_documentation(
        info: { title: 'Virtual Card Public API v1' },
        format: :json,
        produces: %w[application/json],
        schemes: [:http, :https]
      )
    end
  end
end
