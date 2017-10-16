require "rails_helper"

RSpec.describe Medicaid::ContactEmail do
  describe "Validations" do
    context "email nil" do
      it "is valid" do
        step = Medicaid::ContactEmail.new

        expect(step).to be_valid
      end
    end

    context "valid email address" do
      it "is valid" do
        step = Medicaid::ContactEmail.new(email: "test@example.com")
        expect(step).to be_valid
      end
    end

    context "invalid email address" do
      it "is invalid" do
        step = Medicaid::ContactEmail.new(email: "test")
        expect(step).not_to be_valid
      end
    end
  end
end
