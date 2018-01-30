require "rails_helper"

RSpec.describe HouseholdMoreInfoController do
  describe "#update" do
    context "invalid params" do
      it "renders edit" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        put :update, params: {
          step: {
            everyone_a_citizen: nil,
            anyone_disabled: nil,
            anyone_new_mom: nil,
            anyone_in_college: nil,
            anyone_living_elsewhere: nil,
          },
        }

        expect(response).to render_template(:edit)
      end
    end

    context "valid params" do
      let(:valid_params) do
        {
          step: {
            everyone_a_citizen: "false",
            anyone_disabled: "false",
            anyone_new_mom: "false",
            anyone_in_college: "false",
            anyone_living_elsewhere: "false",
          },
        }
      end

      it "updates the snap application" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        put :update, params: valid_params

        snap_application.reload

        expect(snap_application.everyone_a_citizen).to eq(false)
        expect(snap_application.anyone_disabled).to eq(false)
        expect(snap_application.anyone_new_mom).to eq(false)
        expect(snap_application.anyone_in_college).to eq(false)
        expect(snap_application.anyone_living_elsewhere).to eq(false)
      end

      context "everyone is a citizen" do
        let(:params) do
          valid_params.deep_merge(step: { everyone_a_citizen: "true" })
        end

        it "updates each member to reflect citizenship" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.citizen).to eq(true)
          end
        end
      end

      context "not everyone is a citizen" do
        let(:params) do
          valid_params.deep_merge(step: { everyone_a_citizen: "false" })
        end

        it "does not update the members" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.citizen).to be_nil
          end
        end
      end

      context "no one is disabled" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_disabled: "false" })
        end

        it "updates each member to reflect no disability" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.disabled).to eq(false)
          end
        end
      end

      context "someone is disabled" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_disabled: "true" })
        end

        it "does not update the members" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.disabled).to be_nil
          end
        end
      end

      context "no one is new mother" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_new_mom: "false" })
        end

        it "updates each member to reflect that no one is a new mother" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.new_mom).to eq(false)
          end
        end
      end

      context "someone is new mother" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_new_mom: "true" })
        end

        it "does not update the members" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.new_mom).to be_nil
          end
        end
      end

      context "no one is in_college" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_in_college: "false" })
        end

        it "updates each member to reflect not in college" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.in_college).to eq(false)
          end
        end
      end

      context "someone is in_college" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_in_college: "true" })
        end

        it "does not update the members" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.in_college).to be_nil
          end
        end
      end

      context "no one is living_elsewhere" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_living_elsewhere: "false" })
        end

        it "updates each member to reflect not living elsewhere" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.living_elsewhere).to eq(false)
          end
        end
      end

      context "someone is living_elsewhere" do
        let(:params) do
          valid_params.deep_merge(step: { anyone_living_elsewhere: "true" })
        end

        it "does not update the members" do
          members = build_list(:member, 2)

          snap_application = create(
            :snap_application,
            members: members,
          )
          session[:snap_application_id] = snap_application.id

          put :update, params: params

          members.each(&:reload)

          members.each do |member|
            expect(member.living_elsewhere).to be_nil
          end
        end
      end
    end
  end
end
