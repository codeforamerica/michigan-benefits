require "rails_helper"

RSpec.describe Medicaid::ContactMailingAddressController, type: :controller do
  describe "#next_path" do
    it "is the homeless client contact page path" do
      expect(subject.next_path).
        to eq "/steps/medicaid/contact-homeless"
    end
  end

  describe "#edit" do
    context "client has no reliable mailing address" do
      it "renders the edit template" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "mail is sent to residential address" do
      it "redirects to next page" do
        medicaid_application = create(
          :medicaid_application,
          mail_sent_to_residential: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "mail not sent to residential, has no reliable address" do
      it "renders the edit page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: true,
          mail_sent_to_residential: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
