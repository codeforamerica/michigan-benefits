require "rails_helper"

RSpec.describe MedicaidApplication do
  describe "#residential_address" do
    context "mailing_address_same_as_residential_address is true" do
      it "returns mailing address" do
        app = create(:medicaid_application,
                     stable_housing: true,
                     mailing_address_same_as_residential_address: true)
        create(:address, benefit_application: app)
        mailing_address = create(:mailing_address, benefit_application: app)

        expect(app.residential_address).to eq mailing_address
      end
    end

    context "mailing_address_same_as_residential_address is false" do
      context "residential address not present" do
        it "returns NullAddress" do
          app = create(:medicaid_application,
                       stable_housing: true,
                       mailing_address_same_as_residential_address: false)
          create(:mailing_address, benefit_application: app)

          expect(app.residential_address).to be_a NullAddress
        end
      end

      context "residential address present" do
        context "housing is stable" do
          it "returns residential address" do
            app = create(:medicaid_application, stable_housing: true)
            create(:mailing_address, benefit_application: app)
            residential_address = create(:address, benefit_application: app)

            expect(app.residential_address).to eq residential_address
          end
        end

        context "housing is not stable" do
          it "returns NullAddress" do
            app = create(:medicaid_application, stable_housing: false)
            create(:mailing_address, benefit_application: app)
            _residential_address = create(:address, benefit_application: app)

            expect(app.residential_address.class).to eq NullAddress
          end
        end
      end
    end
  end

  describe "#mailing_address" do
    context "mailing address exists" do
      it "returns mailing address" do
        app = create(:medicaid_application)
        mailing_address = create(:mailing_address, benefit_application: app)

        expect(app.mailing_address).to eq(mailing_address)
      end
    end

    context "mailing address does not exist" do
      it "returns NullAddress" do
        app = create(:medicaid_application)
        create(:address, benefit_application: app)

        expect(app.mailing_address.class).to eq(NullAddress)
      end
    end
  end
end
