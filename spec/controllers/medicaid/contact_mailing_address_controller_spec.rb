require "rails_helper"

RSpec.describe Medicaid::ContactMailingAddressController, type: :controller do
  include_examples "application required"

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

      it "pre-populates the data properly if mailing address present" do
        medicaid_application = create(:medicaid_application)
        create(
          :mailing_address,
          street_address: "I receive mail here",
          city: "Hometown",
          zip: "54321",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit
        step = assigns(:step)

        expect(step.street_address).to eq("I receive mail here")
        expect(step.city).to eq("Hometown")
        expect(step.zip).to eq("54321")
      end
    end
  end

  describe "#update" do
    context "when valid" do
      it "redirects to the next step" do
        medicaid_application = create(:medicaid_application)
        session[:medicaid_application_id] = medicaid_application.id

        params = {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
        }

        put :update, params: { step: params }

        expect(response).to redirect_to(subject.next_path)
      end

      context "and no residential address currently exists" do
        it "updates the app and provides default values for county and state" do
          medicaid_application = create(
            :medicaid_application,
            stable_housing: true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          params = {
            street_address: "321 Real St",
            city: "Shelbyville",
            zip: "54321",
          }

          put :update, params: { step: params }

          mailing_address = medicaid_application.reload.mailing_address

          expect(mailing_address.street_address).to eq "321 Real St"
          expect(mailing_address.city).to eq "Shelbyville"
          expect(mailing_address.zip).to eq "54321"
          expect(mailing_address.county).to eq("Genesee")
          expect(mailing_address.state).to eq("MI")
        end
      end

      context "and residential address currently exists" do
        it "updates the residential address" do
          medicaid_application = create(
            :medicaid_application,
            stable_housing: true,
          )
          create(:residential_address,
                 street_address: "456 Fake Street",
                 city: "Jackson",
                 zip: "55555",
                 county: "Blah",
                 state: "CA",
                 mailing: true,
                 benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          params = {
            street_address: "321 Real St",
            city: "Shelbyville",
            zip: "54321",
          }

          put :update, params: { step: params }

          medicaid_application.reload

          mailing_address = medicaid_application.reload.mailing_address

          expect(mailing_address.street_address).to eq "321 Real St"
          expect(mailing_address.city).to eq "Shelbyville"
          expect(mailing_address.zip).to eq "54321"
          expect(mailing_address.county).to eq("Genesee")
          expect(mailing_address.state).to eq("MI")
        end
      end
    end
  end
end
