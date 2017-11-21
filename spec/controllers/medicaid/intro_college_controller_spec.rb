require "rails_helper"

RSpec.describe Medicaid::IntroCollegeController do
  describe "#update" do
    context "single member household" do
      context "anyone in college" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_in_college: true } }

          member.reload

          expect(member).to be_in_college
        end
      end

      context "nobody in college" do
        it "updates the member" do
          member = build(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { anyone_in_college: false } }

          member.reload

          expect(member).not_to be_in_college
        end
      end
    end
  end
end
