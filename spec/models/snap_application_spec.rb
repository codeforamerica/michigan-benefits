require "rails_helper"

RSpec.describe SnapApplication do
  describe "validations" do
    [
      [:care_expenses, SnapApplication::CARE_EXPENSES],
      [:medical_expenses, SnapApplication::MEDICAL_EXPENSES],
      [:court_ordered_expenses, SnapApplication::COURT_ORDERED_EXPENSES],
    ].each do |field, approved_values|
      context field.to_s do
        it "is valid with all allowed values" do
          app = build(
            :snap_application,
            field => approved_values,
          )

          expect(app).to be_valid
        end

        it "is valid with only one allowed value" do
          app = build(
            :snap_application,
            field => [approved_values.first],
          )

          expect(app).to be_valid
        end

        it "is invalid with an arbitrary value" do
          app = build(
            :snap_application,
            field => ["random_word"],
          )

          expect(app).not_to be_valid
        end
      end
    end
  end

  describe "#pdf" do
    it "delegates to the Dhs1171Pdf class" do
      app = build(:snap_application)

      fake_pdf_builder = double(completed_file: "I am fake. It's OK")
      allow(Dhs1171Pdf).to receive(:new).with(snap_application: app).
        and_return(fake_pdf_builder)

      expect(app.pdf).to eql(fake_pdf_builder.completed_file)
    end
  end

  describe "#gross_income" do
    context "no members" do
      it "adds all sources of income" do
        app = build(
          :snap_application,
          income_child_support: nil,
          income_other: nil,
          income_pension: nil,
          income_social_security: nil,
          income_ssi_or_disability: nil,
          income_unemployment_insurance: nil,
          income_workers_compensation: 10,
        )

        expect(app.monthly_gross_income).to eq 10
      end
    end

    context "members present" do
      it "adds members' monthly income" do
        member = create(:member)
        app = create(:snap_application, members: [member])
        allow(member).to receive(:monthly_income).and_return(100)

        expect(app.monthly_gross_income).to eq 100
      end
    end
  end

  describe "#residential_address" do
    context "mailing_address_same_as_residential_address is true" do
      it "returns mailing address" do
        app = create(:snap_application,
                      mailing_address_same_as_residential_address: true)
        create(:address, snap_application: app)
        mailing_address = create(:mailing_address, snap_application: app)

        expect(app.residential_address).to eq mailing_address
      end
    end

    context "mailing_address_same_as_residential_address is false" do
      context "residential address not present" do
        it "returns NullAddress" do
          app = create(:snap_application)
          create(:mailing_address, snap_application: app)

          expect(app.residential_address).to be_a NullAddress
        end
      end

      context "residential address present" do
        context "housing is stable" do
          it "returns residential address" do
            app = create(:snap_application)
            create(:mailing_address, snap_application: app)
            residential_address = create(:address, snap_application: app)

            expect(app.residential_address).to eq residential_address
          end
        end

        context "housing is not stable" do
          it "returns NullAddress" do
            app = create(:snap_application, unstable_housing: true)
            create(:mailing_address, snap_application: app)
            _residential_address = create(:address, snap_application: app)

            expect(app.residential_address.class).to eq NullAddress
          end
        end
      end
    end
  end

  describe "#signed_at_est" do
    context "signed_at present" do
      it "returns the UTC time in EST" do
        # September 1, 2008 10:05:00 AM UTC
        time = Time.utc(2008, 9, 1, 10, 5, 0)
        snap_app = build(:snap_application, signed_at: time)

        Timecop.freeze(time) do
          expect(snap_app.signed_at_est).to eq(
            "09/01/2008 at 06:05AM EDT",
          )
        end
      end
    end

    context "signed_at not present" do
      it "returns nil" do
        snap_app = build(:snap_application, signed_at: nil)

        expect(snap_app.signed_at_est).to eq(nil)
      end
    end
  end

  describe "#faxed?" do
    context "when no fax attempts have been made" do
      it "returns false" do
        snap_application = FactoryGirl.create(:snap_application)
        expect(snap_application).to_not be_faxed
      end
    end

    context "when a failed fax attempt has been made" do
      it "returns false" do
        snap_application = FactoryGirl.create(:snap_application,
          exports: [FactoryGirl.create(:export, :faxed, :failed)])
        expect(snap_application).to_not be_faxed
      end
    end

    context "when a successful fax attempt has been made" do
      it "returns true" do
        snap_application = FactoryGirl.create(:snap_application,
          exports: [FactoryGirl.create(:export, :faxed, :succeeded)])
        expect(snap_application).to be_faxed
      end
    end

    context "when several fax attempts have led to mixed results" do
      it "returns true" do
        snap_application = FactoryGirl.create(:snap_application,
          exports: [FactoryGirl.create(:export, :faxed, :failed),
                    FactoryGirl.create(:export, :faxed, :succeeded),
                    FactoryGirl.create(:export, :faxed, :failed)])
        expect(snap_application).to be_faxed
      end
    end
  end

  describe "#drive_status" do
    context "when there are no drive attempts or errors" do
      it "returns :drive_none" do
        snap_application = create(:snap_application)

        expect(snap_application.drive_status).to eq :drive_none
      end
    end

    context "when there are drive attempts and no errors" do
      it "returns :drive_success" do
        driven_application = create(:driver_application)
        snap_application = driven_application.snap_application

        expect(snap_application.drive_status).to eq :drive_success
      end
    end

    context "when there are drive attempts and some errors" do
      it "returns :drive_errors" do
        driver_error = create(:driver_error)
        driven_application = driver_error.driver_application
        snap_application = driven_application.snap_application

        expect(snap_application.drive_status).to eq :drive_errors
      end
    end
  end
end
