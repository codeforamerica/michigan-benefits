require "rails_helper"

RSpec.describe FaxRecipient do
  subject(:instance) do
    described_class.new(residential_address: residential_address)
  end

  describe "#number" do
    subject(:number) { instance.number }
    context "when the residential_address is for a zip code in clio" do
      let(:residential_address) { double(:residential_address, zip: 48415) }

      it { is_expected.to eql "+16173963015" }

      context "and the app release stage is production" do
        before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }
        it { is_expected.to eql "+18107602310" }
      end
    end

    context "when the residential_address is for a zip code in union" do
      let(:residential_address) { double(:residential_address, zip: 48411) }

      it { is_expected.to eql "+16173963015" }

      context "and the app release stage is production" do
        before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }
        it { is_expected.to eql "+18107602021" }
      end
    end

    context "when the residential_address is for a zip not for either office" do
      let(:residential_address) { double(:residential_address, zip: 12345) }

      it { is_expected.to eql "+16173963015" }

      context "and the app release stage is production" do
        before { stub_const("ENV", "APP_RELEASE_STAGE" => "production") }
        it { is_expected.to eql "+18107602021" }
      end
    end
  end
end
