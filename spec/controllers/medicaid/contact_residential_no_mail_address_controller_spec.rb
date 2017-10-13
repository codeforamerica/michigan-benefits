require "rails_helper"

RSpec.describe Medicaid::ContactResidentialNoMailAddressController do
  describe "#next_path" do
    it "is the phone contact info page path" do
      expect(subject.next_path).to eq "/steps/medicaid/contact-phone"
    end
  end

  describe "#edit" do
    context "no reliable or residential mailing address, and not homeless" do
      it "redirects to next page" do
        medicaid_application = create(
          :medicaid_application,
          mail_sent_to_residential: false,
          reliable_mail_address: false,
          homeless: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
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

    context "mail sent to reliable address" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client is homeless" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          homeless: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
