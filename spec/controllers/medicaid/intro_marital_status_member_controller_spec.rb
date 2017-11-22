require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusMemberController do
  describe "#next_path" do
    it "is the indicate spouse path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/intro-marital-status-indicate-spouse",
      )
    end
  end

  describe "#update" do
    context "application has spouses specified when revisiting page" do
      it "clears spouses on all members" do
        member_one = build(:member, spouse_id: 0)
        member_two = build(:member, spouse_id: 1)

        medicaid_application = create(
          :medicaid_application,
          members: [member_one, member_two],
        )

        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: {
          step: {
            members: {
              member_one.id => { married: true },
              member_two.id => { married: false },
            },
          },
        }

        member_one.reload
        member_two.reload

        expect(member_one.spouse_id).to be_nil
        expect(member_one.married).to eq true
        expect(member_two.spouse_id).to be_nil
        expect(member_two.married).to eq false
      end
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_married,
  )
end
