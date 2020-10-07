module Api::Entities
  class Transaction < Grape::Entity
    expose :id, as: :uuid, documentation: { type: 'UUID', desc: 'Transaction UUID' }
    expose :created_at, documentation: { type: Time, desc: 'Transaction created at' }
    expose :description, documentation: { type: String, desc: 'Transaction description' }
    expose :amount, documentation: { type: BigDecimal, desc: 'Transaction amount' }
  end
end
