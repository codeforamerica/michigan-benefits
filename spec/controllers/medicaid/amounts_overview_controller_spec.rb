# frozen_string_literal: true

require "rails_helper"

RSpec.describe Medicaid::AmountsOverviewController do
  include_examples "application required"

  describe "#skip?" do
    context "receives an income, and has expenses" do
      it "does not skip" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
          anyone_pay_child_support_alimony_arrears: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "receives an income, and has no expenses" do
      it "does not skip" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: true,
          anyone_self_employed: false,
          anyone_pay_child_support_alimony_arrears: false,
          anyone_pay_student_loan_interest: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "has expenses, and no income" do
      it "does not skip" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: false,
          anyone_self_employed: false,
          anyone_other_income: false,
          anyone_pay_child_support_alimony_arrears: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "no income, no expenses" do
      it "skips to the next page" do
        medicaid_application = create(
          :medicaid_application,
          anyone_employed: false,
          anyone_self_employed: false,
          anyone_other_income: false,
          anyone_pay_child_support_alimony_arrears: false,
          anyone_pay_student_loan_interest: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
