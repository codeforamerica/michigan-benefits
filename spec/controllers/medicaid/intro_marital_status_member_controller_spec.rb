require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusMemberController do
  describe "#next_path" do
    it "is the intro college path" do
      expect(subject.next_path).to eq "/steps/medicaid/intro-college"
    end
  end

  describe "#edit" do
    context "someone is married" do
      it "renders :edit" do
        medicaid_application = create(
          :medicaid_application,
          anyone_married: true,
        )
        create_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "no one is married" do
      it "skips this page" do
        medicaid_application = create(
          :medicaid_application,
          anyone_married: false,
        )

        create_list(:member, 2, benefit_application: medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
