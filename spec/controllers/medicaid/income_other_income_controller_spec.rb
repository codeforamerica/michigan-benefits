require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeController do
  describe "#next_path" do
    it "is the self income job number" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-other-income-member",
      )
    end
  end

  describe "#update" do
    context "medicaid app has a single member" do
      context "someone in the household has other income" do
        it "updates the other_income attr of the primary member" do
          member = build(:member)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )

          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_other_income: true } }
          member.reload

          expect(member).to be_other_income
        end
      end

      context "nobody in the household has a job" do
        it "does not update the employment status of the primary member" do
          member = build(:member)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )

          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_other_income: false } }

          expect(member.reload).not_to be_other_income
        end
      end
    end

    context "medicaid app has multiple members" do
      it "does not update the employment status of the primary member" do
        member = build(:member)
        medicaid_application = create(
          :medicaid_application,
          members: [member, build(:member)],
        )

        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: { step: { anyone_other_income: true } }

        expect(member.reload).not_to be_other_income
      end
    end
  end
end
