module Api::Entities
  class TransactionExtended < Transaction
    expose :balance_before, documentation: { type: BigDecimal, desc: 'Balance before transaction' }
    expose :balance_after, documentation: { type: BigDecimal, desc: 'Balance after transaction' }
  end
end
