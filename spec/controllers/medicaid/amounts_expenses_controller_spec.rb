require "rails_helper"

RSpec.describe Medicaid::AmountsExpensesController, type: :controller do
  describe "#next_path" do
    it "is the medicaid contact path" do
      expect(subject.next_path).to eq "/steps/medicaid/contact"
    end
  end

  describe "#edit" do
    context "client not self employed with no student loans or child support" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          pay_student_loan_interest: false,
          anyone_pay_child_support_alimony_arrears: false,
          anyone_self_employed: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client with a student loan" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          pay_student_loan_interest: true,
          anyone_pay_child_support_alimony_arrears: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "client with child support costs" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          pay_student_loan_interest: false,
          anyone_pay_child_support_alimony_arrears: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "client is self employed" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          pay_student_loan_interest: false,
          anyone_pay_child_support_alimony_arrears: false,
          anyone_self_employed: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
