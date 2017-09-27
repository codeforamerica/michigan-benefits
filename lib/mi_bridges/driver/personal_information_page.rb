# frozen_string_literal: true

module MiBridges
  class Driver
    class PersonalInformationPage < BasePage
      TITLE = "Getting Started With Your Application"

      delegate(
        :primary_member,
        :residential_address,
        to: :snap_application,
      )

      def skip_instance_limitation; end

      def setup; end

      def fill_in_required_fields
        fill_in_name
        click_on_gender
        fill_in_birthday_fields(primary_member.birthday)
        select_county
        fill_in_address
        click_same_address_answer
        fill_in_phone_number
      end

      def continue
        click_on "Next"
        click_on "Next" if invalid_physical_address?
      end

      private

      def fill_in_name
        fill_in "First Name", with: primary_member.mi_bridges_formatted_name
        fill_in "Last Name", with: primary_member.last_name
      end

      def click_on_gender
        click_id "gender_#{primary_member.sex.first.upcase}"
      end

      def select_county
        select residential_address.county, from: "whatCounty"
      end

      def fill_in_address
        if snap_application.unstable_housing?
          click_id "homeless"
        end

        fill_in "Street Address",
          with: residential_address.street_address
        fill_in "City",
          with: residential_address.city
        fill_in "Zip Code",
          with: residential_address.zip
      end

      def click_same_address_answer
        if snap_application.mailing_address_same_as_residential_address?
          same_address_letter = "Y"
        else
          same_address_letter = "N"
        end

        click_id "mailInSameAddress_#{same_address_letter}"
      end

      def fill_in_phone_number
        return if snap_application.phone_number.blank?

        phone_number = snap_application.phone_number
        fill_in "phone1homePhone", with: phone_number[0..2]
        fill_in "phone2homePhone", with: phone_number[3..5]
        fill_in "phone3homePhone", with: phone_number[6..9]

        select "Home Phone", from: "bestWayToGetInTouch"
      end

      def invalid_physical_address?
        has_content? "You've entered an invalid physical address"
      end
    end
  end
end
