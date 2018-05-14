require "rails_helper"

RSpec.describe Integrated::JobDetailsController do
  describe "#skip?" do
    context "when no applicants have a job" do
      it "returns true" do
        application = create(:common_application,
          members: build_list(:household_member, 2, employments: []))

        skip_step = Integrated::JobDetailsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "edit" do
    context "when primary member has at least one job" do
      it "assigns the primary member's employments" do
        current_app = create(:common_application,
          members: [
            build(:household_member, employments: []),
            build(:household_member, employments: build_list(:employment, 2)),
          ])

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.employments.count).to eq(2)
      end
    end

    context "when primary member does not have a job" do
      it "assigns the next member's employments" do
        current_app = create(:common_application,
          members: [
            build(:household_member, employments: []),
            build(:household_member, employments: build_list(:employment, 2)),
          ])

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.employments.count).to eq(2)
      end
    end
  end

  describe "#update" do
    let(:member) do
      create(:household_member, employments: [employment_1, employment_2, employment_3])
    end

    let(:employment_1) do
      build(:employment)
    end

    let(:employment_2) do
      build(:employment)
    end

    let(:employment_3) do
      build(:employment)
    end

    context "when member to update belongs to current application" do
      context "with valid params" do
        let(:valid_params) do
          {
            id: member.id,
            employments: {
              employment_1.id => {
                employer_name: "Doublemeat Palace",
                hourly_or_salary: "hourly",
                payment_frequency: "week",
                pay_quantity_hourly: "10",
                hours_per_week: "30",
              },
              employment_2.id => {
                employer_name: "Deepscan",
                pay_quantity_salary: "2000.00",
              },
              employment_3.id => {
                employer_name: "",
                pay_quantity_salary: "",
              },
            },
          }
        end

        it "updates the models" do
          current_app = create(:common_application, members: [member])
          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          member.reload

          first_job = member.employments.first
          second_job = member.employments.second

          expect(first_job.employer_name).to eq("Doublemeat Palace")
          expect(first_job.hourly?).to be_truthy
          expect(first_job.payment_frequency).to eq("week")
          expect(first_job.pay_quantity).to eq("10")
          expect(first_job.hours_per_week).to eq(30)

          expect(second_job.employer_name).to eq("Deepscan")
          expect(second_job.pay_quantity).to eq("2000.00")
        end
      end

      context "with invalid params" do
        let(:invalid_params) do
          {
            id: member.id,
            employments: {
              employment_1.id => {
                hours_per_week: "forty",
              },
            },
          }
        end

        it "renders edit without updating" do
          current_app = create(:common_application, members: [member])
          session[:current_application_id] = current_app.id

          put :update, params: { form: invalid_params }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
