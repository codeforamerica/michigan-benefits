require "rails_helper"

RSpec.describe IncomeAdditionalSourcesController, type: :controller do
  describe "#next_path" do
    it "is the additional income path" do
      snap_application = create(:snap_application)
      session[:snap_application_id] = snap_application.id

      expect(subject.next_path).to eq "/steps/income-additional"
    end
  end

  describe "#edit" do
    it "renders edit" do
      snap_application = create(:snap_application)
      session[:snap_application_id] = snap_application.id

      get :edit

      expect(response).to render_template(:edit)
    end

    it "assigns attributes to the step" do
      snap_application = create(
        :snap_application,
        additional_income: ["other", "child_support"],
      )
      session[:snap_application_id] = snap_application.id

      get :edit

      step = assigns(:step)

      expect(step.child_support).to eq(true)
      expect(step.other).to eq(true)
      expect(step.pension).to be_nil
      expect(step.social_security).to be_nil
      expect(step.ssi_or_disability).to be_nil
      expect(step.unemployment_insurance).to be_nil
      expect(step.workers_compensation).to be_nil
    end
  end

  describe "#update" do
    context "when valid additional income selected" do
      it "updates additional income with all selected checkboxes" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        put :update, params: {
          step: {
            unemployment_insurance: "1",
            child_support: "1",
            ssi_or_disability: "0",
          },
        }

        expect(snap_application.reload.additional_income).to match_array(
          ["unemployment_insurance", "child_support"],
        )
      end

      it "redirects to the next step" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        put :update, params: {
          step: {
            unemployment_insurance: "1",
            child_support: "1",
            ssi_or_disability: "0",
          },
        }

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
