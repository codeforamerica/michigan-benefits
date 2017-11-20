require "rails_helper"

RSpec.describe Medicaid::IntroCitizenController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/intro-citizen-member"
    end
  end

  describe "#update" do
    context "multi member househoold" do
      context "everyone a citizen" do
        it "updates the members" do
          members = create_list(:member, 2)

          medicaid_application = create(
            :medicaid_application,
            members: members,
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { everyone_a_citizen: true } }

          members.each(&:reload)

          members.each do |member|
            expect(member).to be_citizen
          end
        end
      end
    end

    context "single member household" do
      context "is a citizen" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { everyone_a_citizen: true } }

          member.reload

          expect(member).to be_citizen
        end
      end

      context "is not a citizen" do
        it "updates the member" do
          member = create(:member)

          medicaid_application = create(
            :medicaid_application,
            members: [member],
          )
          session[:medicaid_application_id] = medicaid_application.id

          put :update, params: { step: { everyone_a_citizen: false } }

          member.reload

          expect(member).not_to be_citizen
        end
      end
    end
  end
end
