class ValidationResult
  attr_reader :errors

  def initialize(errors = [])
    @errors = errors
  end

  def errors?
    errors.any?
  end

  alias invalid? errors?

  def valid?
    !invalid?
  end

  def error_messages
    errors.join(', ')
  end

  def ==(other)
    other.errors.sort == errors.sort
  end
  alias eq ==

  def +(other)
    ValidationResult.new(errors + other.errors)
  end
end
