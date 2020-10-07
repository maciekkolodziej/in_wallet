FactoryBot.define do
  factory :transaction do
    virtual_card
    description "Test transaction"
    amount 500.0
    balance_before 0
    balance_after -500.0
  end
end
