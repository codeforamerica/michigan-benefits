require "rails_helper"

RSpec.describe SsnMigrater do
  describe "#run" do
    context "ssn is present, last_four_ssn not present" do
      it "moves last four of ssn to last_four_ssn" do
        medicaid_app = create(
          :medicaid_application,
          ssn: "111223333",
          last_four_ssn: nil,
        )

        member = create(
          :member,
          ssn: "444556666",
          last_four_ssn: nil,
        )

        SsnMigrater.new.run
        medicaid_app.reload
        member.reload

        expect(medicaid_app.last_four_ssn).to eq "3333"
        expect(member.last_four_ssn).to eq "6666"
      end
    end

    context "ssn is not present" do
      it "does not update last_four_ssn" do
        medicaid_app = create(
          :medicaid_application,
          ssn: nil,
          last_four_ssn: nil,
        )

        member = create(
          :member,
          ssn: nil,
          last_four_ssn: nil,
        )

        SsnMigrater.new.run
        medicaid_app.reload
        member.reload

        expect(medicaid_app.last_four_ssn).to eq nil
        expect(member.last_four_ssn).to eq nil
      end
    end

    context "ssn and last_four_ssn present" do
      it "does not update last_four_ssn" do
        medicaid_app = create(
          :medicaid_application,
          ssn: "111223333",
          last_four_ssn: "4444",
        )

        member = create(
          :member,
          ssn: "444556666",
          last_four_ssn: "7777",
        )

        SsnMigrater.new.run
        medicaid_app.reload
        member.reload

        expect(medicaid_app.last_four_ssn).to eq "4444"
        expect(member.last_four_ssn).to eq "7777"
      end
    end
  end
end
