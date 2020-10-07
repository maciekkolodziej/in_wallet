module Api::Public::V1
  class Health < Grape::API
    get :health do
      :ok
    end
  end
end
