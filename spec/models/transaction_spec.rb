require "rails_helper"

describe Transaction, type: :model do
  describe "validations" do
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_length_of(:description).is_at_least(0) }
  end

  describe "scopes" do
    describe ".from_card" do
      subject { Transaction.from_card("4999888877776666") }

      let!(:virtual_card) { create(:virtual_card, number: "4999888877776666") }
      let!(:transaction_1) { create(:transaction, virtual_card: virtual_card) }
      let!(:transaction_2) { create(:transaction, virtual_card: virtual_card) }
      let!(:transaction_from_different_account) { create(:transaction) }

      it "returns only transactions made from virtual card with specified number" do
        expect(subject).to match_array([transaction_1, transaction_2])
      end
    end

    describe ".created_between" do
      subject { Transaction.created_between(from_time, to_time) }

      let(:from_time) { DateTime.new(2020, 10, 4, 8, 20) }
      let(:to_time) { DateTime.new(2020, 10, 4, 11, 20) }


      let!(:transaction_1) { create(:transaction, created_at: DateTime.new(2020, 10, 4, 8, 21)) }
      let!(:transaction_2) { create(:transaction, created_at: DateTime.new(2020, 10, 4, 10, 00)) }
      let!(:transaction_3) { create(:transaction, created_at: DateTime.new(2020, 10, 4, 11, 20)) }
      let!(:transaction_before) do
        create(:transaction, created_at: DateTime.new(2020, 10, 4, 8, 19))
      end
      let!(:transaction_after) do
        create(:transaction, created_at: DateTime.new(2020, 10, 4, 11, 53))
      end

      it "returns only transactions in given period in time" do
        expect(subject).to match_array([transaction_1, transaction_2, transaction_3])
      end
    end
  end
end
