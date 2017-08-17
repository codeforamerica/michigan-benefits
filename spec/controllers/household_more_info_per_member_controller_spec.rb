require "rails_helper"

RSpec.describe HouseholdMoreInfoPerMemberController do
  let(:step) { assigns(:step) }

  before { session[:snap_application_id] = current_app.id }

  describe "#update" do
    context "when valid" do
      it "updates the member attributes if they are present" do
        params = {
          step: {
            members: {
              member_one.id => { disabled: "1", in_college: "0" },
              member_two.id => { in_college: "1", disabled: "0" },
            },
          },
        }

        put :update, params: params

        expect(member_one.reload).to be_disabled
        expect(member_two.reload).to be_in_college
      end
    end
  end

  def current_app
    @_current_app ||=
      create(:snap_application, members: [member_one, member_two])
  end

  def member_one
    @_member_one ||= create(:member, disabled: nil)
  end

  def member_two
    @_member_two ||= create(:member, in_college: false)
  end
end
