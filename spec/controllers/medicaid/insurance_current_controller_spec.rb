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

          put :update, params: { step: { anyone_insured: true } }

          member.reload

          expect(member).to be_insured
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

          put :update, params: { step: { anyone_insured: false } }

          member.reload

          expect(member).to_not be_insured
        end
      end
    end
  end
end
