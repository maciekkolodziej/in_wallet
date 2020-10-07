require "rails_helper"

describe Api::Public::V1::Transactions, type: :request do
  describe "POST /transactions" do
    subject(:post_request) { post("/api/public/v1/transactions", params: params) }

    let!(:virtual_card) { create(:virtual_card, number: "4111222233334444") }
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
      it "uses VirtualCardService::ChargeCard to charge the card and create transaction" do
        expect(VirtualCardsService::ChargeCard).to receive(:call).with(params).and_call_original

        expect { post_request }.to change { Transaction.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(response_body["uuid"]).to eq(Transaction.last.id)
        expect(response_body["amount"]).to eq("500.0")
        expect(response_body["description"]).to eq(description)
      end
    end

    context "when card doesn't exist" do
      let(:card_number) { "1234" }

      it "returns 404 with error message" do
        post_request

        expect(response).to have_http_status(:not_found)
        expect(response_body).to eq({ "message" => %w[couldn_t_find_virtualcard]})
      end
    end

    context "when params are invalid (grape validation)" do
      let(:amount) { "A" }
      let(:description) { "" }

      it "returns 422 with error message" do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({ "message" => %w[description_is_empty amount_is_invalid]})
      end
    end

    context "when cvv has 4 digits, but it is not the right cvv (service validation)" do
      let(:cvv) { "0000" }

      it "returns 422 with error message" do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({ "message" => %w[invalid_cvv]})
      end
    end

    context "when amount is less than 0 (internal model validation)" do
      let(:amount) { -350 }

      it "returns 422 with error message" do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
        error_response = { "message" => %w[validation_failed_amount_must_be_greater_than_0]}
        expect(response_body).to eq(error_response)
      end
    end
  end
end
