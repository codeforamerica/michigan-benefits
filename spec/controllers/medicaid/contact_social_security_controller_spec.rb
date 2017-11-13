require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurityController do
  describe "#next_path" do
    it "is the paperwork guide page" do
      expect(subject.next_path).to eq "/steps/medicaid/paperwork-guide"
    end
  end

  describe "#edit" do
    context "client will not submitssn" do
      it "redirects to next step" do
        medicaid_application = create(:medicaid_application, submit_ssn: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client will submit ssn" do
      it "renders edit" do
        medicaid_application = create(:medicaid_application, submit_ssn: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
