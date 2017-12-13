module MiBridges
  class Driver
    class CreateAccountConfirmationPage < BasePage
      def self.title
        "Congratulations"
      end

      def setup; end

      def fill_in_required_fields; end

      def continue
        click_on "Click here"
      end
    end
  end
end
