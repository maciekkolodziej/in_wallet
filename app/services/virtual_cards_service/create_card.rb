module VirtualCardsService
  class CreateCard < ApplicationService
    def initialize(name:, cvv:, limit: 0)
      @name = name
      @cvv = cvv.to_s
      @limit = limit.to_d.round(2)
    end

    def call
      raise ValidationFailed.new(:invalid_cvv_needs_to_have_3_digits) unless cvv_valid?

      @card = VirtualCard.new(name: name, limit: limit)
      generate_unique_number
      encrypt_cvv
      card.save!
      self
    end

    def result
      card
    end

    private

    attr_reader :name, :cvv, :limit, :card

    def cvv_valid?
      /\A[0-9]{3}\z/.match?(cvv)
    end

    def generate_unique_number
      while card.number.blank? || VirtualCard.find_by(number: card.number)
        card.number = CardNumberGenerator.call
      end
    end

    def encrypt_cvv
      card.encrypted_cvv = Digest::SHA256.hexdigest(cvv)
    end
  end
end
