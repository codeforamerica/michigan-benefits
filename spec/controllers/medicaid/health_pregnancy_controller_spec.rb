require "rails_helper"

RSpec.describe Medicaid::HealthPregnancyController, type: :controller do
  describe "#next_path" do
    it "is the  path" do
      expect(subject.next_path).to eq "/steps/medicaid/health-pregnancy-member"
    end
  end

  describe "#edit" do
    context "members are all male" do
      it "redirects to the next page" do
        medicaid_application = create(:medicaid_application)
        create(
          :member,
          sex: "male",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "members include a female" do
      it "renders :edit" do
        medicaid_application = create(:medicaid_application)
        create(
          :member,
          sex: "female",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
