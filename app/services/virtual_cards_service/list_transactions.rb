module VirtualCardsService
  class ListTransactions < ApplicationService
    def initialize(card_number:, from_time: nil, to_time: nil)
      @card_number = card_number
      @from_time = from_time ? parse_time(from_time) : Date.current.beginning_of_day
      @to_time = to_time ? parse_time(to_time) : Date.current.end_of_day
    end

    def call
      @transactions = Transaction
        .from_card(card_number)
        .created_between(from_time, to_time)
        .order(created_at: :asc)

      self
    end

    def result
      {
        total_count: transactions.count,
        results: transactions
      }
    end

    private

    attr_reader :card_number, :from_time, :to_time, :transactions

    def parse_time(time)
      Time.find_zone("UTC").parse(time)
    end
  end
end
