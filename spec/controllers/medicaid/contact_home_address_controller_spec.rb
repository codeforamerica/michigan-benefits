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
        medicaid_application = create(
          :medicaid_application,
          stable_housing: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end

      it "pre-populates the data properly" do
        medicaid_application = create(
          :medicaid_application,
          stable_housing: true,
        )
        create(
          :residential_address,
          street_address: "I live here",
          street_address_2: "Apt B",
          city: "Hometown",
          zip: "54321",
          benefit_application: medicaid_application,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit
        step = assigns(:step)

        expect(step.street_address).to eq("I live here")
        expect(step.street_address_2).to eq("Apt B")
        expect(step.city).to eq("Hometown")
        expect(step.zip).to eq("54321")
      end

      context "mailing address not the same as residential address is nil" do
        it "sets the default of mailing_address_same_as_residential_address" do
          medicaid_application = create(
            :medicaid_application,
            stable_housing: true,
            mailing_address_same_as_residential_address: nil,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          step = assigns(:step)
          expect(step.mailing_address_same_as_residential_address).
            to eq true
        end
      end

      context "mailing address not the same as residential address is false" do
        it "sets the default of mailing_address_same_as_residential_address" do
          medicaid_application = create(
            :medicaid_application,
            stable_housing: true,
            mailing_address_same_as_residential_address: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          step = assigns(:step)
          expect(step.mailing_address_same_as_residential_address).
            to eq false
        end
      end
    end

    context "client does not have stable housing" do
      it "redirects to the next page" do
        medicaid_application = create(
          :medicaid_application,
          stable_housing: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end

  describe "#update" do
    context "when valid" do
      let(:medicaid_application) { create(:medicaid_application) }

      before(:each) do
        session[:medicaid_application_id] = medicaid_application.id
      end

      it "redirects to the next step" do
        params = {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          mailing_address_same_as_residential_address: true,
        }

        put :update, params: { step: params }

        expect(response).to redirect_to(subject.next_path)
      end

      context "and no residential address currently exists" do
        it "updates the app" do
          params = {
            street_address: "321 Real St",
            street_address_2: "Apt B",
            city: "Shelbyville",
            zip: "54321",
            mailing_address_same_as_residential_address: "false",
          }

          put :update, params: { step: params }

          residential_address = medicaid_application.reload.residential_address

          expect(residential_address.street_address).to eq "321 Real St"
          expect(residential_address.street_address_2).to eq "Apt B"
          expect(residential_address.city).to eq "Shelbyville"
          expect(residential_address.zip).to eq "54321"
          expect(
            medicaid_application.mailing_address_same_as_residential_address,
          ).to eq false
        end
      end

      context "and residential address currently exists" do
        it "updates the residential address" do
          create(:residential_address,
                 street_address: "456 Fake Street",
                 city: "Jackson",
                 zip: "55555",
                 benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          params = {
            street_address: "321 Real St",
            city: "Shelbyville",
            zip: "54321",
            mailing_address_same_as_residential_address: "false",
          }

          put :update, params: { step: params }

          residential_address = medicaid_application.reload.residential_address

          expect(residential_address.street_address).to eq "321 Real St"
          expect(residential_address.city).to eq "Shelbyville"
          expect(residential_address.zip).to eq "54321"
          expect(
            medicaid_application.mailing_address_same_as_residential_address,
          ).to eq false
        end
      end

      it "sets the county based on address" do
        params = {
          street_address: "321 Real St",
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
        }

        county_finder = instance_double(CountyFinder)
        expect(CountyFinder).to receive(:new).with(
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          state: "MI",
        ).and_return(county_finder)
        allow(county_finder).to receive(:run).and_return("Wayne")

        put :update, params: { step: params }

        residential_address = medicaid_application.reload.residential_address

        expect(residential_address.county).to eq("Wayne")
      end


      it "sets the state to 'MI'" do
        params = {
          street_address: "321 Real St",
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
        }

        put :update, params: { step: params }

        residential_address = medicaid_application.reload.residential_address

        expect(residential_address.state).to eq("MI")
      end
    end
  end
end
