require "rails_helper"

RSpec.describe Medicaid::ContactHomeAddressController, type: :controller do
  describe "#next_path" do
    it "is the contact address (other) page path" do
      expect(subject.next_path).to eq "/steps/medicaid/contact-other-address"
    end
  end

  describe "#edit" do
    context "client has stable housing" do
      it "renders the edit page" do
        medicaid_application =
          create(
            :medicaid_application,
            stable_housing: true,
          )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end

      context "client does not have stable housing" do
        it "redirects to the next page" do
          medicaid_application =
            create(
              :medicaid_application,
              stable_housing: false,
            )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
