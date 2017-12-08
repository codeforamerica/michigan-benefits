module MiBridges
  class Driver
    class PeopleListedPage < BasePage
      def self.title
        "People Listed On Your Application"
      end

      def setup
        @member = if for_next_household_member?
                    find_not_yet_added_member
                  else
                    snap_application.primary_member
                  end
      end

      def fill_in_required_fields
        if member.marital_status.present?
          select member.marital_status.titleize, from: "maritalStatus"
        else
          select "Never Married", from: "maritalStatus"
        end

        select_fap_program_enrollment
        select_citizenship
        fill_in_social_security_number

        if for_next_household_member?
          fill_in "firstName", with: member.mi_bridges_formatted_name
          fill_in "lastName", with: member.last_name
          click_id "gender_#{member.sex.first.upcase}"
          fill_in_birthday_fields(member.birthday)
          select_yes_person_lives_at_same_address
        else
          fill_in "peopleInYourHome", with: snap_application.members.size
        end
      end

      def continue
        click_on "Next"
      end

      private

      attr_reader :member

      def for_next_household_member?
        has_content? "Please tell us about the next person in your home."
      end

      def find_not_yet_added_member
        snap_application.members.detect do |member|
          member_first_name = Regexp.new(escape_parens_in_name(member))
          !page.has_content?(member_first_name)
        end
      end

      def escape_parens_in_name(member)
        Regexp.escape(member.mi_bridges_formatted_name)
      end

      def select_fap_program_enrollment
        if member.requesting_food_assistance?
          click_id("requestFoodShare")
        end
      end

      def select_citizenship
        if member.citizen?
          click_citizenship_label(
            for_label: "Yes",
          )
        elsif member.citizen == false
          click_citizenship_label(
            for_label: "No",
          )
        end
      end

      def click_citizenship_label(for_label: "")
        selector = "label:contains('#{for_label}')"
        widget = "[aria-labelledby='uSCitizenLbl']"
        js_click_selector("#{widget} #{selector}")
      end

      def fill_in_social_security_number
        return if member.ssn.blank?

        ssn = member.ssn
        fill_in "ssn1socialSecurity", with: ssn[0..2]
        fill_in "ssn2socialSecurity", with: ssn[3..4]
        fill_in "ssn3socialSecurity", with: ssn[5..8]
        fill_in "ssn1confirmSocialSecurity", with: ssn[0..2]
        fill_in "ssn2confirmSocialSecurity", with: ssn[3..4]
        fill_in "ssn3confirmSocialSecurity", with: ssn[5..8]
      end

      def select_yes_person_lives_at_same_address
        click_id("liveInSameAddress_Y")
      end
    end
  end
end
