# frozen_string_literal: true

module MiBridges
  class Driver
    class StartPage < BasePage
      def setup
        check_page_title(
          "Help With Filing MI Bridges Application",
        )
      end

      def fill_in_required_fields
        click_id(a_staff_person_or_volunteer_at_an_agency)
      end

      def continue
        click_on "Next"
      end

      private

      def a_staff_person_or_volunteer_at_an_agency
        "#radioGroup_2"
      end
    end
  end
end
