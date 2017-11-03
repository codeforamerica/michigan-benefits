module MiBridges
  class Driver
    class PrivacyPinPage < BasePage
      def self.title
        "Privacy PIN"
      end

      def setup; end

      def fill_in_required_fields
        click_id(this_is_a_private_computer_id)
      end

      def continue
        click_on "Next"
      end

      private

      def this_is_a_private_computer_id
        "#radioGroup_No"
      end
    end
  end
end
