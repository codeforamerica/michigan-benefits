require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberContinuedController do
  describe "#next_path" do
    it "is the self employment page path" do
      expect(subject.next_path).to eq "/steps/medicaid/income-job-number-member"
    end
  end

  describe "#edit" do
    context "medicaid app has multiple members" do
      it "redirects to the next step" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
          members: create_list(:member, 2),
        )

        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "medicaid app has a single member" do
      context "client is has 4+ jobs" do
        it "renders edit" do
          member = create(:member, employed_number_of_jobs: 5)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
            anyone_employed: true,
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "client has fewer than 4 jobs" do
        it "redirects to the next page" do
          member = create(:member, employed_number_of_jobs: 3)
          medicaid_application = create(
            :medicaid_application,
            members: [member],
            anyone_employed: true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "nobody in the household has a job" do
        it "skips the step" do
          medicaid_application = create(
            :medicaid_application,
            :with_member,
            anyone_employed: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end

  describe "#update" do
    it "updates the job number count for the primary member" do
      member = create(:member)
      medicaid_application = create(:medicaid_application, members: [member])

      session[:medicaid_application_id] = medicaid_application.id

      put :update, params: { step: { employed_number_of_jobs: 9 } }

      expect(member.reload.employed_number_of_jobs).to eq 9
    end
  end
end
