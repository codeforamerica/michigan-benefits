require "rails_helper"

RSpec.describe Medicaid::HealthDisabilityController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/health-disability-member"
    end
  end

  describe "#update" do
    context "single member household" do
      context "is disabled" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_disabled: true } }

          member.reload

          expect(member).to be_disabled
        end
      end

      context "is not disabled" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_disabled: false } }

          member.reload

          expect(member).not_to be_disabled
        end
      end
    end
  end
end
