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
    context "when no job counts are set" do
      it "sets a job count of 1 for a solo applicant" do
        current_app = create(:common_application, :single_member,
                             navigator: build(:application_navigator, current_job: true))
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.members.first.job_count).to eq(1)
      end

      it "sets a job count of 0 for all in a multi-member household" do
        current_app = create(:common_application, :multi_member,
                             navigator: build(:application_navigator))
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.members.first.job_count).to eq(0)
        expect(form.members.second.job_count).to eq(0)
      end
    end

    context "when a job count is already set" do
      it "respects the count" do
        current_app = create(:common_application,
                             members: [build(:household_member, job_count: 3)],
                             navigator: build(:application_navigator, current_job: true))
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.members.first.job_count).to eq(3)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:member_1) do
        create(:household_member)
      end

      let(:member_2) do
        create(:household_member)
      end

      let(:valid_params) do
        {
          members: {
            member_1.id => {
              job_count: "1",
            },
            member_2.id => {
              job_count: "2",
            },
          },
        }
      end

      it "updates each member with job count" do
        current_app = create(:common_application,
                             members: [member_1, member_2],
                             navigator: build(:application_navigator))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.job_count).to eq(1)
        expect(member_2.job_count).to eq(2)
      end
    end
  end
end
