module Api::Public::V1
  class Transactions < Grape::API
    resource :transactions do
      desc 'Creates a new transaction' do
        success Api::Entities::Transaction
        failure [[422, 'API error', Api::Entities::ApiError]]
      end
      params do
        requires :card_number, type: String, allow_blank: false, desc: "Virtual card number"
        requires :cvv, type: String, allow_blank: false, desc: "Virtual card CVV code"
        requires :description, type: String, allow_blank: false, desc: "Transaction description"
        requires :amount, type: BigDecimal, allow_blank: false, desc: "Transaction amount"
      end
      post do
        service = VirtualCardsService::ChargeCard.call(
          card_number: params[:card_number],
          cvv: params[:cvv],
          description: params[:description],
          amount: params[:amount]
        )
        present service.result, with: Api::Entities::Transaction
      end
    end
  end
end
