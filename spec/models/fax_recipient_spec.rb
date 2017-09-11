require "rails_helper"

RSpec.describe FaxRecipient do
  describe "#number" do
    context "address is in clio" do
      it "uses the sandbox fax number" do
        residential_address = double(zip: "48415")
        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq sandbox_fax_number
      end
    end

    context "address is in union" do
      it "uses the sandbox fax number" do
        residential_address = double(zip: "48411")
        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq sandbox_fax_number
      end
    end

    context "address outside of clio or union" do
      it "falls back to sandbox number" do
        residential_address = double(zip: "98765")
        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq sandbox_fax_number
      end
    end

    context "when the app release stage is production" do
      before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }

      context "office location is present" do
        it "defaults to office location over residential address" do
          residential_address = double(zip: "12345")
          office_location = "clio"
          snap_application = double(
            residential_address: residential_address,
            office_location: office_location,
          )

          fax_recipient = described_class.new(
            snap_application: snap_application,
          )

          expect(fax_recipient.number).to eq clio_fax_number
        end

        it "defaults to office location over residential address" do
          residential_address = double(zip: "12345")
          office_location = "union"
          snap_application = double(
            residential_address: residential_address,
            office_location: office_location,
          )

          fax_recipient = described_class.new(
            snap_application: snap_application,
          )

          expect(fax_recipient.number).to eq union_fax_number
        end
      end

      it "uses the appropriate fax number when the address is in clio" do
        residential_address = double(zip: "48415")
        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq clio_fax_number
      end

      it "uses the appropriate fax number when the address is in union" do
        residential_address = double(zip: "48411")
        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq union_fax_number
      end

      it "falls back to the clio office" do
        residential_address = double(zip: "123456")

        snap_application = double(
          residential_address: residential_address,
          office_location: nil,
        )

        fax_recipient = described_class.new(
          snap_application: snap_application,
        )

        expect(fax_recipient.number).to eq clio_fax_number
      end
    end
  end

  def sandbox_fax_number
    "+16173963015"
  end

  def clio_fax_number
    "+18107602310"
  end

  def union_fax_number
    "+18107607372"
  end
end
