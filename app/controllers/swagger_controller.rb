class SwaggerController < ApplicationController
  def public
    @swagger_doc = "api/public/v1/swagger_doc"
  end

  def private
    @swagger_doc = "api/private/v1/swagger_doc"
  end
end
