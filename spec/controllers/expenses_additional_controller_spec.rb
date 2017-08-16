# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpensesAdditionalController, type: :controller do
  let(:step) { assigns(:step) }
  let(:step_class) { ExpensesAdditional }

  describe "#edit" do
    context "existing application" do
      it "assigns the fields to the step" do
        current_app = create(
          :snap_application,
          court_ordered: true,
          monthly_care_expenses: 123,
          monthly_medical_expenses: 234,
          monthly_court_ordered_expenses: 345,
          monthly_tax_deductible_expenses: 456,
        )
        session[:snap_application_id] = current_app.id

        get :edit

        expect(step.monthly_care_expenses).to eq(123)
        expect(step.monthly_medical_expenses).to eq(234)
        expect(step.monthly_court_ordered_expenses).to eq(345)
        expect(step.monthly_tax_deductible_expenses).to eq(456)
      end
    end

    context "when previous step has had more than one affirmative answer" do
      it "assigns the correct step" do
        current_app = create(:snap_application, court_ordered: true)
        session[:snap_application_id] = current_app.id

        get :edit

        expect(step).to be_an_instance_of step_class
      end

      it "renders the edit page" do
        current_app = create(:snap_application, court_ordered: true)
        session[:snap_application_id] = current_app.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "when previous step is `false` across the board" do
      it "redirects to the next step" do
        current_app = create(:snap_application)
        session[:snap_application_id] = current_app.id

        get :edit

        expect(response).to redirect_to(subject.send(:next_path))
      end
    end
  end
end
