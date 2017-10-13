require "rails_helper"

RSpec.describe Medicaid::ContactHomelessController, type: :controller do
  describe "#next_path" do
    it "is the 'no mailing address' page path" do
      expect(subject.next_path).
        to eq "/steps/medicaid/contact-residential-no-mail-address"
    end
  end

  describe "#edit" do
    context "client has no reliable mailing address" do
      it "renders the edit template" do
        medicaid_application = create(
          :medicaid_application,
          mail_sent_to_residential: false,
          reliable_mail_address: false,
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

    context "mail is sent to a reliable mailing address" do
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
  end
end
