# frozen_string_literal: true

module MiBridges
  class Driver
    class StartPage < BasePage
      TITLE = "Help With Filing MI Bridges Application"

      def setup; end

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
