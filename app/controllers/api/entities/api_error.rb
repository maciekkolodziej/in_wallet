module Api
  module Entities
    class ApiError < Grape::Entity
      expose :message,
             documentation: {
               type: String,
               desc: 'Error message'
             }
    end
  end
end
