require "rails_helper"

RSpec.describe AuthorizedRepresentative do
  describe "Validations" do
    context "applicant has an authorized rep but did not provide name" do
      it "is invalid" do
        step = AuthorizedRepresentative.new(
          authorized_representative: true,
          authorized_representative_name: "",
        )
        step.valid?

        expect(step.errors.count).to eq(1)
        expect(step.errors[:authorized_representative_name]).
          to eq(["Make sure to enter your legal representative's full name"])
      end
    end

    context "applicant has an authorized rep and provided name" do
      it "is valid" do
        step = AuthorizedRepresentative.new(
          authorized_representative: true,
          authorized_representative_name: "Googly",
        )
        expect(step).to be_valid
      end
    end

    context "applicant doesn't have an authorized rep" do
      it "is valid" do
        step = AuthorizedRepresentative.new(
          authorized_representative: "false",
        )
        expect(step).to be_valid
      end
    end

    context "applicant doesn't indicate whether they have an authorized rep" do
      it "is invalid" do
        step = AuthorizedRepresentative.new(
          authorized_representative: nil,
        )
        expect(step).not_to be_valid
        expect(step.errors.count).to eq(1)
        expect(step.errors[:authorized_representative]).
          to eq(["Make sure to answer this question"])
      end
    end
  end
end
