require "rails_helper"

RSpec.describe Medicaid::CitizensController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/insurance-needed"
    end
  end

  describe "#edit" do
    context "everyone in the home is a citizen" do
      it "skips this page" do
        medicaid_application =
          create(
            :medicaid_application,
            citizen: true,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "someone in the home is not a use citizen" do
      it "renders :edit" do
        medicaid_application =
          create(
            :medicaid_application,
            citizen: false,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
