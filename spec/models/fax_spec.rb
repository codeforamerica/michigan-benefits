# frozen_string_literal: true

require "rails_helper"

RSpec.describe Fax do
  describe ".send_fax" do
    it "initializes SFax with rails secrets" do
      fake_faxer = double(send_fax: true)
      allow(SFax::Faxer).to receive(:new).and_return(fake_faxer)

      Fax.send_fax(
        number: "+18005550000",
        file: "file.pdf",
        recipient: "Michigan Benefits",
      )

      expect(SFax::Faxer).to have_received(:new).with(
        Rails.application.secrets.sfax_username,
        Rails.application.secrets.sfax_api_key,
        Rails.application.secrets.sfax_init_vector,
        Rails.application.secrets.sfax_encryption_key,
      )
    end

    it "sends a file to desired number with sfax" do
      fake_faxer = double(send_fax: true)
      allow(SFax::Faxer).to receive(:new).and_return(fake_faxer)

      Fax.send_fax(
        number: "+18005550000",
        file: "file.pdf",
        recipient: "Michigan Benefits",
      )

      expect(fake_faxer).to have_received(:send_fax).
        with("+18005550000", "file.pdf", "Michigan Benefits")
    end
  end
end
