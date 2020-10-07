module Api
  class Root < Grape::API
    format :json
    helpers Api::Helpers::Defaults
    insert_after Grape::Middleware::Formatter, Grape::Middleware::Logger

    rescue_from ActiveRecord::RecordNotFound, with: :error_record_not_found_ar
    rescue_from Grape::Exceptions::ValidationErrors, with: :error_validation_failed_grape
    rescue_from ActiveRecord::RecordInvalid, with: :error_record_invalid
    rescue_from ValidationFailed, with: :error_validation_failed
    rescue_from Grape::Exceptions::MethodNotAllowed, with: :error_method_not_allowed
    rescue_from RoutingFailed, with: :error_routing_failed

    rescue_from :all, with: :error_unknown

    mount Private::V1::Root
    mount Public::V1::Root

    route :any, '*path' do
      raise RoutingFailed.new("No such route: #{request.url}")
    end
  end
end
