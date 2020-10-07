module VirtualCardsService
  class CardNumberGenerator < ApplicationService
    def initialize; end

    def call
      (["4", rand.to_s[2..16]].join)
    end
  end
end
