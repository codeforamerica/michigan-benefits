require "rails_helper"

RSpec.describe Medicaid::PaperworkController, type: :controller do
  describe "#next_path" do
    it "is the success page path" do
      expect(subject.next_path).to eq "/steps/medicaid/success"
    end
  end

  describe "#edit" do
    context "client doesn't want to upload docs at that time" do
      it "redirects to next step" do
        medicaid_application = create(
          :medicaid_application,
          upload_paperwork: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client wants to upload docs" do
      it "renders the edit page" do
        medicaid_application = create(
          :medicaid_application,
          upload_paperwork: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
