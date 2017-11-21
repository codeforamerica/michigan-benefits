require "rails_helper"

RSpec.describe IncomeDetailsPerMemberController do
  let(:step) { assigns(:step) }

  before { session[:snap_application_id] = current_app.id }

  describe "#update" do
    context "when valid" do
      it "updates the member attributes if they are present" do
        params = {
          step: {
            members: {
              member.id => {
                employed_employer_name: "Baseball hat",
              },
            },
          },
        }

        put :update, params: params

        expect(response).to redirect_to "/steps/income-additional-sources"
        expect(member.reload.employed_employer_name).to eq "Baseball hat"
      end
    end

    context "when invalid" do
      it "does not update the member attributes" do
        params = {
          step: {
            members: {
              member.id => {
                employed_employer_name: "",
              },
            },
          },
        }

        put :update, params: params

        expect(response).to render_template(:edit)
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def member
    @_member ||= build(:member, employment_status: "employed")
  end
end
