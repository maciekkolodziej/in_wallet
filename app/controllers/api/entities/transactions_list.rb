module Api::Entities
  class TransactionsList < Grape::Entity
    expose :total_count,
           documentation: { type: Integer, desc: 'Total number of found transactions' }
    expose :results, using: Api::Entities::TransactionExtended,
           documentation: { is_array: true, desc: 'Application array' }
  end
end
