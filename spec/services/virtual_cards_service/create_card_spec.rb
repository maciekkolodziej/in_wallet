require "rails_helper"

describe VirtualCardsService::CreateCard do
  describe "#call" do
    let(:service_call) { described_class.call(params) }
    let(:params) { { name: name, cvv: cvv, limit: limit } }
    let(:name) { "Elon Musk" }
    let(:cvv) { "123" }
    let(:limit) { 1_000.12345 }

    context "when params are valid" do
      it "generates card number, encrypts the cvv and saves virtual card with rounded limit" do
        expect(
          VirtualCardsService::CardNumberGenerator
        ).to receive(:call).once { "4111222233334444" }
        expect(Digest::SHA256).to receive(:hexdigest).with("123") { "encrypted_cvv" }
        expect_any_instance_of(VirtualCard).to receive(:save!).and_call_original

        expect { service_call }.to change { VirtualCard.count }.by(1)

        card = VirtualCard.last
        expect(card.name).to eq("Elon Musk")
        expect(card.number).to eq("4111222233334444")
        expect(card.encrypted_cvv).to eq("encrypted_cvv")
        expect(card.limit).to eq(1_000.12)
      end
    end

    context "when provided cvv is invalid" do
      let(:cvv) { "12" }

      it "raises validation error" do
        expect {
          service_call
        }.to raise_exception(ValidationFailed, "invalid_cvv_needs_to_have_3_digits")
      end
    end

    context "when generated card number is already taken" do
      let!(:virtual_card) { create(:virtual_card, number: "4111222233335555")}

      it "generates the number again" do
        expect(
          VirtualCardsService::CardNumberGenerator
        ).to receive(:call).once { "4111222233335555" }
        expect(
          VirtualCardsService::CardNumberGenerator
        ).to receive(:call).once { "4111222233336666" }
        expect_any_instance_of(VirtualCard).to receive(:save!).and_call_original

        expect { service_call }.to change { VirtualCard.count }.by(1)
      end
    end
  end
end
