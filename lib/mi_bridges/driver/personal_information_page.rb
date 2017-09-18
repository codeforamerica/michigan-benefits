# frozen_string_literal: true

module MiBridges
  class Driver
    class PersonalInformationPage < BasePage
      delegate(
        :primary_member,
        :residential_address,
        to: :snap_application,
      )

      def setup
        check_page_title(
          "Getting Started With Your Application",
        )
      end

      def fill_in_required_fields
        fill_in_name
        click_on_gender
        fill_in_birthday_fields
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
        fill_in "First Name", with: primary_member.first_name
        fill_in "Last Name", with: primary_member.last_name
      end

      def click_on_gender
        click_id "gender_#{primary_member.sex.first.upcase}"
      end

      def fill_in_birthday_fields
        month = padded(primary_member.birthday.month)
        day = padded(primary_member.birthday.day)
        year = primary_member.birthday.year

        fill_in "monthgroupDateOfBirth", with: month
        fill_in "dategroupDateOfBirth", with: day
        fill_in "yeargroupDateOfBirth", with: year

        fill_in "monthconfirmGroupDateOfBirth", with: month
        fill_in "dateconfirmGroupDateOfBirth", with: day
        fill_in "yearconfirmGroupDateOfBirth", with: year
      end

      def select_county
        select residential_address.county, from: "whatCounty"
      end

      def fill_in_address
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

      def padded(int)
        sprintf("%02d", int)
      end

      def invalid_physical_address?
        has_content? "You've entered an invalid physical address"
      end
    end
  end
end
