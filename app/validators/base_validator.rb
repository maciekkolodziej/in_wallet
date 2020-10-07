class BaseValidator
  attr_accessor :context
  attr_reader :errors

  def initialize(*args)
    @context = Hashie::Mash.new(*args)
  end

  def validate(object)
    clear_errors!
    validate!(object)
    ValidationResult.new(errors.uniq)
  end

  def validate!(_)
    raise NotImplementedError
  end

  private

  def clear_errors!
    @errors = []
  end

  def add_error(message)
    @errors << message
  end
end
