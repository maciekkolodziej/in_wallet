class ApplicationService
  private_class_method :new

  def self.call(*args)
    new(*args).call
  end

  def initialize(*)
    raise NotImplementedError
  end

  def call
    raise NotImplementedError
  end
end
