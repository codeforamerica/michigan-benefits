require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentController do
  describe "#update" do
    context "single member household" do
      context "anyone is insured" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_is_insured: true } }

          member.reload

          expect(member.is_insured?).to eq(true)
        end
      end

      context "nobody insured" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_is_insured: false } }

          member.reload

          expect(member.is_insured?).to eq(false)
        end
      end
    end
  end
end
