class VirtualCard < ActiveRecord::Base
  has_many :transactions

  def available_amount
    [limit + balance, 0].max
  end
end
