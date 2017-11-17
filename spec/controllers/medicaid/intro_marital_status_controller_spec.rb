require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusController do
  include_examples "application required"

  describe "#update" do
    context "single member household" do
      context "anyone married" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_married: true } }

          member.reload

          expect(member).to be_married
        end
      end

      context "nobody married" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_married: false } }

          member.reload

          expect(member).not_to be_married
        end
      end
    end
  end
end
