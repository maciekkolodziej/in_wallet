class Transaction < ActiveRecord::Base
  belongs_to :virtual_card

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 3 }

  scope :from_card, -> (number) { joins(:virtual_card).where(virtual_cards: { number: number }) }
  scope :created_between, lambda { |from, to|
    where("transactions.created_at BETWEEN ? AND ?", from, to)
  }
end
