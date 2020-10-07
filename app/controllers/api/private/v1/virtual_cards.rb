module Api::Private::V1
  class VirtualCards < Grape::API
    resource :virtual_cards do
      desc 'Creates a new virtual card' do
        success Api::Entities::VirtualCard
        failure [[422, 'API error', Api::Entities::ApiError]]
      end
      params do
        requires :name, type: String, allow_blank: false, desc: "Name printed on virtual card"
        requires :cvv, type: String, allow_blank: false, desc: "3 digit CVV code"

        optional :limit, type: BigDecimal, desc: "Credit limit on the card"
      end
      post do
        service = VirtualCardsService::CreateCard.call(
          name: params[:name],
          cvv: params[:cvv],
          limit: params[:limit]
        )
        present service.result, with: Api::Entities::VirtualCard
      end

      desc 'Return virtual card details' do
        success Api::Entities::VirtualCardExtended
        failure [[422, 'API error', Api::Entities::ApiError]]
      end
      route_param :number, type: String do
        get do
          present VirtualCard.find_by!(number: params[:number]),
                  with: Api::Entities::VirtualCardExtended
        end
      end

      desc 'Returns list of transactions in selected date range' do
        success Api::Entities::TransactionsList
        failure [[422, 'API error', Api::Entities::ApiError]]
      end
      params do
        optional :from_time, type: String
        optional :to_time, type: String
      end
      route_param :number, type: String do
        get :transactions do
          service = VirtualCardsService::ListTransactions.call(
            card_number: params[:number],
            from_time: params[:from_time],
            to_time: params[:to_time]
          )
          present service.result, with: Api::Entities::TransactionsList
        end
      end
    end
  end
end
