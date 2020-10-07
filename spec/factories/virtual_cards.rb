FactoryBot.define do
  factory :virtual_card do
    name "Lex Fridman"
    number { VirtualCardsService::CardNumberGenerator.call }
    encrypted_cvv { Digest::SHA256.hexdigest("123") }
    limit 1_000
  end
end
