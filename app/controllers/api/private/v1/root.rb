module Api::Private::V1
  class Root < Grape::API
    format :json
    prefix "private/v1"

    mount VirtualCards

    if Rails.env.development? || Rails.env.staging?
      add_swagger_documentation(
        info: { title: 'Virtual Card Private API v1' },
        format: :json,
        produces: %w[application/json],
        schemes: [:http, :https]
      )
    end
  end
end
