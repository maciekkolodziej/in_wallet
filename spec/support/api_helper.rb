# -*- encoding : utf-8 -*-
module ApiHelper
  def response_body
    @response_body ||= JSON.parse(response.body)
  end
end
