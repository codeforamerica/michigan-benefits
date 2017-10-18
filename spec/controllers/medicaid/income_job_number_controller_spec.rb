require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberController do
  let(:step) { assigns(:step) }

  describe "#next_path" do
    it "is the self employment page path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-job-number-continued",
      )
    end
  end

  describe "#edit" do
    context "client has 4 or more jobs" do
      it "sets the job number to 4" do
        medicaid_application = create(
          :medicaid_application,
          employed: true,
          new_number_of_jobs: 5,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
        expect(step.new_number_of_jobs).to eq(4)
      end
    end

    context "client is employed" do
      it "renders edit " do
        medicaid_application =
          create(
            :medicaid_application,
            employed: true,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "client is unemployed" do
      it "redirects to the next page" do
        medicaid_application =
          create(
            :medicaid_application,
            employed: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
