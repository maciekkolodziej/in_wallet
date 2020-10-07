module Api::Helpers
  module Defaults
    extend Grape::API::Helpers

    GRAPE_MESSAGE_COMMA_SEPARATED = "are missing, at least one parameter must be provided".freeze

    def internal_api_error!(error, status)
      log_error(status, error)
      error!(clean_message(Rack::Utils::HTTP_STATUS_CODES[status]), status)
    end

    def log_error(code, error)
      Rails.logger.error(
        "ERROR #{code}: #{error.class}: #{error.message} #{error.backtrace}"
      )
    end

    def custom_error!(error, message, code = 422, log = true)
      log_error(code, error) if log
      error!({ message: clean_message(message), with: Api::Entities::ApiError }, code)
    end

    def error_validation_failed(error)
      custom_error!(error, error.messages, 422, false)
    end

    # Grape::Exceptions::ValidationErrors
    def error_validation_failed_grape(error)
      messages = error.full_messages.map do |message|
        if message.include? GRAPE_MESSAGE_COMMA_SEPARATED
          at_least_one_provided_error_message(message)
        else
          message
        end
      end
      custom_error!(error, messages, 422, false)
    end

    # ActiveRecord::RecordInvalid
    def error_record_invalid(error)
      custom_error!(error, error.message.split(', '))
    end

    # ActiveRecord::RecordNotFound
    def error_record_not_found_ar(error)
      custom_error!(error, error.message, 404)
    end

    # RecordNotFound
    def error_record_not_found(error)
      custom_error!(error, error.message.split(', '), 404)
    end

    def error_record_already_exists(error)
      custom_error!(error, error.message.split(', '), 403)
    end

    # ExternalApiError
    def error_external_api_error(error)
      custom_error!(error, error.message.split(', '), 500)
    end

    # RequestTimeout
    def error_request_timeout(error)
      internal_api_error!(error, 408)
    end

    def error_unknown(error)
      internal_api_error!(error, 500)
    end

    def error_routing_failed(error)
      internal_api_error!(error, 404)
    end

    def error_method_not_allowed(error)
      internal_api_error!(error, 405)
    end

    private

    def at_least_one_provided_error_message(message)
      messages = message.split(', ')
      messages.pop
      messages[-1].slice! ' are missing'
      messages = messages.join("_or_")
      messages + "_missing"
    end

    def clean_message(messages)
      Array(messages).map { |message| message.parameterize(separator: "_") }
    end
  end
end
