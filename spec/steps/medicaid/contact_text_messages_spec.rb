require "rails_helper"

RSpec.describe Medicaid::ContactTextMessages do
  describe "Validations" do
    context "sms phone number nil" do
      it "is valid" do
        step = Medicaid::ContactTextMessages.new(sms_phone_number: nil)

        expect(step).to be_valid
      end
    end

    context "sms phone number present" do
      it "validates length" do
        step = Medicaid::ContactTextMessages.new(sms_phone_number: "123123")

        expect(step).to be_invalid
        expect(step.errors[:sms_phone_number]).to include(
          "Make sure your phone number is 10 digits long",
        )
      end
    end
  end
end
