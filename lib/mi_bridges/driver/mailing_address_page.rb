# frozen_string_literal: true

module MiBridges
  class Driver
    class MailingAddressPage < BasePage
      TITLE = "Mailing Address"

      delegate :mailing_address, to: :snap_application
      delegate(
        :city,
        :county,
        :state,
        :street_address,
        :zip,
        to: :mailing_address,
      )

      def setup; end

      def fill_in_required_fields
        fill_in "Street Address or P.O. Box Number", with: street_address
        select county, from: "County"
        fill_in "City", with: city
        fill_in "Zip Code", with: zip
      end

      def continue
        click_on "Next"
      end
    end
  end
end
