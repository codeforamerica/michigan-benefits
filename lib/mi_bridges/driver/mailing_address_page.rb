# frozen_string_literal: true

module MiBridges
  class Driver
    class MailingAddressPage < BasePage
      delegate(
        :primary_member,
        :mailing_address,
        to: :snap_application,
      )

      def setup; end

      def fill_in_required_fields
        fill_in "Street Address or P.O. Box Number",
          with: mailing_address.street_address
        select mailing_address.county, from: "mailingAdrCounty"
        fill_in "City", with: mailing_address.city
        fill_in "Zip Code", with: mailing_address.zip
      end

      def continue
        click_on "Next"
        click_on "Next" if invalid_physical_address?
      end

      private

      def invalid_physical_address?
        has_content? "You have entered an invalid mailing address"
      end
    end
  end
end
