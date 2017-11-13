require "rails_helper"

RSpec.describe Medicaid::SignAndSubmitController do
  describe "#next_path" do
    it "is the success path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/success",
      )
    end
  end

  describe "#update" do
    it "updates the signature" do
      medicaid_application = create(
        :medicaid_application,
        signature: "Hans Solo",
        signed_at: nil,
      )
      session[:medicaid_application_id] = medicaid_application.id

      expect do
        put :update, params: { step: { signature: "Chiu Baka" } }
      end.to change {
        medicaid_application.reload.signature
      }.from("Hans Solo").to("Chiu Baka")

      expect(medicaid_application.signed_at).not_to be nil
    end
  end
end
