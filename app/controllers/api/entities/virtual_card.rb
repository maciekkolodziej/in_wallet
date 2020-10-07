module Api::Entities
  class VirtualCard < Grape::Entity
    expose :id, as: :uuid, documentation: { type: 'UUID', desc: 'Virtual card UUID' }
    expose :name, documentation: { type: String, desc: 'Name on the card' }
    expose :number, documentation: { type: String, desc: 'Card number' }
    expose :limit, documentation: { type: BigDecimal, desc: 'Card limit' }
  end
end
