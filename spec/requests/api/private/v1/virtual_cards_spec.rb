require "rails_helper"

describe Api::Private::V1::VirtualCards, type: :request do
  describe "POST /virtual_cards" do
    let(:post_request) { post("/api/private/v1/virtual_cards", params: params) }

    context "when params are valid" do
      let(:params) { { name: "Lex Fridman", cvv: "123", limit: "3_000" } }
      let(:service_attrs) { { name: "Lex Fridman", cvv: "123", limit: 3_000.to_d } }

      it "uses VirtualCardService::Create card to create virtual card" do
        expect(
          VirtualCardsService::CreateCard
        ).to receive(:call).with(service_attrs).and_call_original

        expect { post_request }.to change { VirtualCard.count }.by(1)

        expect(response).to have_http_status(:created)

        card = VirtualCard.last
        expect(card.name).to eq("Lex Fridman")
        expect(card.limit).to eq(3_000)
        expect(card.balance).to eq(0)

        expected_response = {
          uuid: card.id,
          name: "Lex Fridman",
          number: card.number,
          limit: "3000.0"
        }.stringify_keys
        expect(response_body).to eq(expected_response)
      end
    end

    context "when params are invalid" do
      let(:params) { { name: "", cvv: "", limit: "ASD" } }

      it "returns 422 with error message" do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({ "message" => %w[name_is_empty cvv_is_empty limit_is_invalid]})
      end
    end

    context "when internal validation failed" do
      let(:params) { { name: "Lex1", cvv: "123", limit: "ASD" } }

      it "returns 422 with error message from internal validation" do
        post_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to eq({ "message" => %w[limit_is_invalid]})
      end
    end
  end

  describe "GET /virtual_cards/:number" do
    let!(:virtual_card) { create(:virtual_card, number: "4111222233334444") }
    let(:get_request) { get("/api/private/v1/virtual_cards/4111222233334444") }

    it "returns virtual card details" do
      get_request

      expect(response).to have_http_status(:ok)
      expect(response_body["uuid"]).to eq(virtual_card.id)
      expect(response_body["name"]).to eq("Lex Fridman")
      expect(response_body["number"]).to eq("4111222233334444")
      expect(response_body["limit"]).to eq("1000.0")
    end
  end
end
