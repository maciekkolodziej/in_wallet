module VirtualCardsService
  class ChargeCard < ApplicationService
    def initialize(card_number:, cvv:, description:, amount:)
      @card_number = card_number
      @cvv = cvv
      @description = description
      @amount = amount
    end

    def call
      find_card
      raise ValidationFailed.new(:invalid_cvv) unless cvv_correct?
      raise ValidationFailed.new(:limit_exceeded) unless sufficient_funds?

      build_transaction
      transaction.validate!

      ActiveRecord::Base.transaction do
        update_card_balance
        transaction.save!
      end

      self
    end

    def result
      transaction
    end

    private

    attr_reader :card_number, :cvv, :description, :amount, :card, :transaction

    def find_card
      @card = VirtualCard.find_by!(number: card_number)
    end

    def sufficient_funds?
      card.available_amount >= amount
    end

    def cvv_correct?
      Digest::SHA256.hexdigest(cvv) == card.encrypted_cvv
    end

    def update_card_balance
      balance_before = transaction.balance_before = card.balance
      balance_after = balance_before - amount
      transaction.balance_after = balance_after
      card.update_columns(balance: balance_after)
    end

    def build_transaction
      @transaction = Transaction.new(
        virtual_card: card,
        description: description,
        amount: amount
      )
    end
  end
end
