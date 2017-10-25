require "rails_helper"

RSpec.describe Medicaid::IncomeSelfEmploymentController do
  describe "#next_path" do
    it "is the self income job number" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-self-employment-member",
      )
    end
  end

  describe "#update" do
    context "medicaid app has a single member" do
      context "someone in the household is self employed" do
        it "updates the self_employment attr of the primary member" do
          member = create(:member)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )

          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_self_employed: true } }
          member.reload

          expect(member).to be_self_employed
        end
      end

      context "nobody in the household has a job" do
        it "does not update the employment status of the primary member" do
          member = create(:member)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )

          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_self_employed: false } }

          expect(member.reload).not_to be_self_employed
        end
      end
    end

    context "medicaid app has multiple members" do
      it "does not update the employment status of the primary member" do
        member = create(:member)
        medicaid_application = create(
          :medicaid_application,
          members: [member, create(:member)],
        )

        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: { step: { anyone_self_employed: true } }

        expect(member.reload).not_to be_self_employed
      end
    end
  end
end
