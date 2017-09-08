require "rails_helper"

RSpec.describe FaxRecipient do
  describe "#number" do
    it "uses the appropriate fax number when the address is in clio" do
      residential_address = double(zip: "48415")
      fax_recipient = described_class.new(residential_address:
                                            residential_address)
      expect(fax_recipient.number).to eql "+16173963015"
    end

    it "uses the appropriate fax number when the address is in union" do
      residential_address = double(zip: "48411")
      fax_recipient = described_class.new(residential_address:
                                            residential_address)
      expect(fax_recipient.number).to eql "+16173963015"
    end

    it "falls back to union when the address is outside of clio or union" do
      residential_address = double(zip: "98765")
      fax_recipient = described_class.new(residential_address:
                                            residential_address)
      expect(fax_recipient.number).to eql "+16173963015"
    end

    context "when the app release stage is production" do
      before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }
      it "uses the appropriate fax number when the address is in clio" do
        residential_address = double(zip: "48415")
        fax_recipient = described_class.new(residential_address:
                                              residential_address)
        expect(fax_recipient.number).to eql "+18107602310"
      end

      it "uses the appropriate fax number when the address is in union" do
        residential_address = double(zip: "48411")
        fax_recipient = described_class.new(residential_address:
                                              residential_address)
        expect(fax_recipient.number).to eql "+18107607372"
      end

      it "falls back to the clio office" do
        residential_address = double(zip: "123456")
        fax_recipient = described_class.new(residential_address:
                                              residential_address)
        expect(fax_recipient.number).to eql "+18107602310"
      end
    end
  end
end
