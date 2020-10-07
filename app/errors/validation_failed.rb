class ValidationFailed < StandardError
  attr_reader :params
  def initialize(error_message = nil, params = {})
    @error_message = Array(error_message).map(&:to_s).presence
    @params = params
    super(@error_message)
  end

  def message
    @error_message.try(:first) || super
  end

  def messages
    @error_message || []
  end
end
