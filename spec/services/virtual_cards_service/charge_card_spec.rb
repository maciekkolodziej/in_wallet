require "rails_helper"

describe VirtualCardsService::ChargeCard do
  describe "#call" do
    let(:service_call) { described_class.call(params) }
    let(:virtual_card) { build(:virtual_card, number: "4111222233334444") }

    let(:params) do
      {
        card_number: card_number,
        cvv: cvv,
        description: description,
        amount: amount
      }
    end
    let(:card_number) { "4111222233334444" }
    let(:cvv) { "123" }
    let(:description) { "Test transaction #1" }
    let(:amount) { 500.0 }

    context "when params are valid" do
      let!(:virtual_card) { create(:virtual_card, number: card_number) }

      it "decreases card balance and saves the transaction with card balances before and after" do
        expect(virtual_card.balance).to eq(0.0)

        expect { service_call }.to change { Transaction.count }.by(1)

        expect(virtual_card.reload.balance).to eq(-500.0)

        transaction = Transaction.last
        expect(transaction.virtual_card).to eq(virtual_card)
        expect(transaction.description).to eq(description)
        expect(transaction.amount).to eq(500.0)
        expect(transaction.balance_before).to eq(0.0)
        expect(transaction.balance_after).to eq(-500.0)
      end
    end

    context "when card doesn't exist" do
      let!(:virtual_card) { create(:virtual_card, number: "4111222233334444") }
      let(:card_number) { "X" }

      it "raises Activerecord::RecordNotFound error" do
        expect { service_call }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context "when cvv is incorrect" do
      let(:virtual_card) { build_stubbed(:virtual_card, number: "4111222233334444") }
      let(:cvv) { "1235" }

      before { allow(VirtualCard).to receive(:find_by!) { virtual_card } }

      it "raises ValidationFailed error with invalid_cvv message" do
        expect { service_call }.to raise_exception(ValidationFailed, "invalid_cvv")
      end
    end

    context "when there are no sufficient funds on the card" do
      let(:virtual_card) { build_stubbed(:virtual_card, number: "4111222233334444") }
      let(:amount) { 1_100 }

      before { allow(VirtualCard).to receive(:find_by!) { virtual_card } }

      it "raises ValidationFailed error with limit_exceeded message" do
        expect { service_call }.to raise_exception(ValidationFailed, "limit_exceeded")
      end
    end

    context "when transaction amount is invalid" do
      let(:virtual_card) { build_stubbed(:virtual_card, number: "4111222233334444") }
      let(:amount) { -100 }

      before { allow(VirtualCard).to receive(:find_by!) { virtual_card } }

      it "raises ActiveRecord::RecordInvalid error with message" do
        error_msg = "Validation failed: Amount must be greater than 0"
        expect { service_call }.to raise_exception(ActiveRecord::RecordInvalid, error_msg)
      end
    end
  end
end
