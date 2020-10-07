module Api::Entities
  class VirtualCardExtended < VirtualCard
    expose :balance, documentation: { type: BigDecimal, desc: 'Current card balance' }
    expose :available_amount, documentation: { type: BigDecimal, desc: 'Limit left to use' }
  end
end
