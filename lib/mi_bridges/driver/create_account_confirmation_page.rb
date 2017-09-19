# frozen_string_literal: true

module MiBridges
  class Driver
    class CreateAccountConfirmationPage < BasePage
      def setup
        check_page_title("Congratulations")
      end

      def fill_in_required_fields; end

      def continue
        click_on "Click here"
      end
    end
  end
end
