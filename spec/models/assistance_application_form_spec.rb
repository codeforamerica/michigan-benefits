require "spec_helper"
require_relative "../../app/models/concerns/pdf_attributes"
require_relative "../../app/models/null_address"
require_relative "../../app/forms/assistance_application_form"

RSpec.describe AssistanceApplicationForm do
  describe "#attributes" do
    let(:residential_address) { NullAddress.new }
    let(:mailing_address) { NullAddress.new }
    let(:unstable_housing?) { nil }
    let(:primary_member) do
      double(:member,
        birthday: DateTime.new(1991, 10, 18))
    end

    let(:snap_application) do
      double(
        :snap_application,
        display_name: "Octopus Cuttlefish",
        unstable_housing?: unstable_housing?,
        residential_address: residential_address,
        mailing_address: mailing_address,
        primary_member: primary_member,
        phone_number: "8005551234",
        email: "hello@multibenefits.org",
        signature: "Octopus G Cuttlefish",
        signed_at_est: "01/22/2018",
      )
    end

    subject do
      AssistanceApplicationForm.new(snap_application).attributes
    end

    context "an application with one member" do
      it "returns a hash with basic information" do
        expect(subject).to include(
          legal_name: "Octopus Cuttlefish",
          dob: "10/18/1991",
          phone_home: "(800) 555-1234",
          email: "hello@multibenefits.org",
          applying_for_food: "Yes",
          signature_applicant: "Octopus G Cuttlefish",
          signature_date: "01/22/2018",
        )
      end
    end

    context "an application with one address for residential and mailing" do
      let(:address) do
        double(
          :address,
          street_address: "123 Main St",
          street_address_2: "Apt 4",
          city: "Flint",
          county: "Gennessee",
          state: "Michigan",
          zip: "12345",
        )
      end

      let(:residential_address) { address }
      let(:mailing_address) { address }
      let(:unstable_housing?) { false }

      it "returns residential address attributes" do
        expect(subject).to include(
          residential_address_street: "123 Main St",
          residential_address_apt: "Apt 4",
          residential_address_city: "Flint",
          residential_address_county: "Gennessee",
          residential_address_state: "Michigan",
          residential_address_zip: "12345",
          is_homeless: nil,
          mailing_address: nil,
        )
      end
    end

    context "an application with different addresses for residential and mailing" do
      let(:residential_address) do
        double(
          :address,
          street_address: "123 Main St",
          street_address_2: "Apt 4",
          city: "Flint",
          county: "Gennessee",
          state: "Michigan",
          zip: "12345",
        )
      end
      let(:mailing_address) do
        double(
          :address,
          street_address: "1 Mailing Lane",
          street_address_2: nil,
          city: "Flint",
          county: "Gennessee",
          state: "Michigan",
          zip: "12345",
        )
      end

      let(:unstable_housing?) { false }

      it "returns residential address attributes" do
        expect(subject).to include(
          residential_address_street: "123 Main St",
          residential_address_apt: "Apt 4",
          residential_address_city: "Flint",
          residential_address_county: "Gennessee",
          residential_address_state: "Michigan",
          residential_address_zip: "12345",
          is_homeless: nil,
          mailing_address: "1 Mailing Lane, Flint, Gennessee, Michigan, 12345",
        )
      end
    end

    context "an application without a stable address" do
      let(:residential_address) { NullAddress.new }
      let(:unstable_housing?) { true }

      it "returns is_homeless attribute" do
        expect(subject).to include(
          is_homeless: "Yes",
          residential_address_street: nil,
          residential_address_apt: nil,
          residential_address_city: nil,
          residential_address_county: nil,
          residential_address_state: nil,
          residential_address_zip: nil,
          mailing_address: nil,
        )
      end
    end
  end
end
