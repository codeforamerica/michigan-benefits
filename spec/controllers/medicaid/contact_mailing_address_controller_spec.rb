require "rails_helper"

RSpec.describe Medicaid::ContactMailingAddressController, type: :controller do
  describe "#next_path" do
    it "is the contact phone path" do
      expect(subject.next_path).
        to eq "/steps/medicaid/contact-phone"
    end
  end

  describe "#edit" do
    context "client first selects reliable mailing address, unchecks
      mailing_address_same_as_residential_address and submits form then clicks
      back twice and says that they do not have a reliable mailing address" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: false,
          mailing_address_same_as_residential_address: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client has no reliable mailing address" do
      it "renders the edit template" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: false,
          mailing_address_same_as_residential_address: nil,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "client has reliable mailing address" do
      it "renders the edit page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: true,
          mailing_address_same_as_residential_address: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "mailing address is the same as residential address" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: nil,
          mailing_address_same_as_residential_address: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "mailing address is not the same as residential address" do
      it "renders the edit page" do
        medicaid_application = create(
          :medicaid_application,
          reliable_mail_address: nil,
          mailing_address_same_as_residential_address: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
