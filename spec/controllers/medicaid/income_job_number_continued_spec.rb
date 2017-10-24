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
        medicaid_application =
          create(
            :medicaid_application,
            :with_member,
            employed: true,
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
          medicaid_application = create(
            :medicaid_application,
            :with_member,
            employed: true,
            number_of_jobs: 4,
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "client has fewer than 4 jobs" do
        it "redirects to the next page" do
          medicaid_application = create(
            :medicaid_application,
            :with_member,
            employed: true,
            number_of_jobs: 3,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "client does not have a job" do
        it "skips the step" do
          medicaid_application = create(
            :medicaid_application,
            :with_member,
            employed: false,
            number_of_jobs: nil,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
