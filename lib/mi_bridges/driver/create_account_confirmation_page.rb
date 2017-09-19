# frozen_string_literal: true

module MiBridges
  class Driver
    class CreateAccountConfirmationPage < BasePage
      TITLE = "Congratulations"

      def setup
        check_page_title(TITLE)
      end

      def fill_in_required_fields; end

      def continue
        click_on "Click here"
      end
    end
  end
end
