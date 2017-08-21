require "rails_helper"

RSpec.describe SnapApplication do
  describe "#gross_income" do
    context "no members" do
      it "adds all sources of income" do
        app = build(
          :snap_application,
          income_child_support: nil,
          income_foster_care: nil,
          income_other: nil,
          income_pension: nil,
          income_social_security: nil,
          income_ssi_or_disability: nil,
          income_unemployment_insurance: nil,
          income_workers_compensation: 10,
        )

        expect(app.monthly_gross_income).to eq 10
      end
    end

    context "members present" do
      it "adds members' monthly income" do
        member = create(:member)
        app = create(:snap_application, members: [member])
        allow(member).to receive(:monthly_income).and_return(100)

        expect(app.monthly_gross_income).to eq 100
      end
    end
  end
end
