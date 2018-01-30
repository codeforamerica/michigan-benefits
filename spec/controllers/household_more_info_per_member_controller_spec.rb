require "rails_helper"

RSpec.describe HouseholdMoreInfoPerMemberController do
  let(:snap_application) do
    create(:snap_application, members: [member_one, member_two])
  end

  let(:member_one) { build(:member) }
  let(:member_two) { build(:member) }

  before do
    session[:snap_application_id] = snap_application.id
  end

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

    context "when no members selected" do
      context "for disabled" do
        it "updates anyone_disabled on the application" do
          snap_application.update(anyone_disabled: true)

          params = {
            step: {
              members: {
                member_one.id => { disabled: "0" },
                member_two.id => { disabled: "0" },
              },
            },
          }

          put :update, params: params

          snap_application.reload

          expect(snap_application.anyone_disabled).to eq(false)
        end
      end

      context "for new mom" do
        it "updates anyone_new_mom on the application" do
          snap_application.update(anyone_new_mom: true)

          params = {
            step: {
              members: {
                member_one.id => { new_mom: "0" },
                member_two.id => { new_mom: "0" },
              },
            },
          }

          put :update, params: params

          snap_application.reload

          expect(snap_application.anyone_new_mom).to eq(false)
        end
      end

      context "for college" do
        it "updates anyone_in college on the application" do
          snap_application.update(anyone_in_college: true)

          params = {
            step: {
              members: {
                member_one.id => { in_college: "0" },
                member_two.id => { in_college: "0" },
              },
            },
          }

          put :update, params: params

          snap_application.reload

          expect(snap_application.anyone_in_college).to eq(false)
        end
      end

      context "living elsewhere" do
        it "updates anyone_living_elsewhere on the application" do
          snap_application.update(anyone_living_elsewhere: true)

          params = {
            step: {
              members: {
                member_one.id => { living_elsewhere: "0" },
                member_two.id => { living_elsewhere: "0" },
              },
            },
          }

          put :update, params: params

          snap_application.reload

          expect(snap_application.anyone_living_elsewhere).to eq(false)
        end
      end
    end

    context "when all members selected" do
      context "for citizenship" do
        it "updates everyone_a_citizen on the application" do
          snap_application.update(everyone_a_citizen: false)

          params = {
            step: {
              members: {
                member_one.id => { citizen: "1" },
                member_two.id => { citizen: "1" },
              },
            },
          }

          put :update, params: params

          snap_application.reload

          expect(snap_application.everyone_a_citizen).to eq(true)
        end
      end
    end
  end
end
