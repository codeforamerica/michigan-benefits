require "rails_helper"

RSpec.describe Integrated::HowManyJobsController do
  describe "#skip?" do
    context "when a single member household and no current job" do
      it "returns true" do
        application = create(:common_application, :single_member,
                             navigator: build(:application_navigator, current_job: false))

        skip_step = Integrated::HowManyJobsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#edit" do
    it "assigns members" do
      member_one = build(:household_member, employments: build_list(:employment, 3))
      member_two = build(:household_member, employments: [])

      current_app = create(:common_application,
                           members: [member_one, member_two],
                           navigator: build(:application_navigator))

      session[:current_application_id] = current_app.id

      get :edit

      form = assigns(:form)

      expect(form.members.first).to eq(member_one)
      expect(form.members.second).to eq(member_two)
    end
  end

  describe "#update" do
    context "when job count changes" do
      let(:member_1) do
        create(:household_member, employments: build_list(:employment, 3))
      end

      let(:member_2) do
        create(:household_member)
      end

      let(:valid_params) do
        {
          members: {
            member_1.id => { employments_count: "1" },
            member_2.id => { employments_count: "2" },
          },
        }
      end

      it "creates the correct number of employments for submitted number of jobs" do
        current_app = create(:common_application,
                             members: [member_1, member_2],
                             navigator: build(:application_navigator))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.employments.count).to eq(1)
        expect(member_2.employments.count).to eq(2)
      end

      it "redirects to next step" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "when job count does not change" do
      let(:member_1) do
        create(:household_member, employments: [
                 build(:employment, employer_name: "Cogsworth's Cogs"),
               ])
      end

      let(:member_2) do
        create(:household_member, employments: [
                 build(:employment, employer_name: "Spatula City"),
               ])
      end

      let(:valid_params) do
        {
          members: {
            member_1.id => { employments_count: "1" },
            member_2.id => { employments_count: "1" },
          },
        }
      end

      it "does not overwrite the existing jobs" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.employments.count).to eq(1)
        expect(member_1.employments.first.employer_name).to eq("Cogsworth's Cogs")
        expect(member_2.employments.count).to eq(1)
        expect(member_2.employments.first.employer_name).to eq("Spatula City")
      end
    end
  end
end
