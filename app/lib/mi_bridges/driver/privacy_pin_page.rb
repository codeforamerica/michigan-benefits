module MiBridges
  class Driver
    class PrivacyPinPage < FillInAndClickNextPage
      def self.title
        "Privacy PIN"
      end

      def fill_in_required_fields
        wait_until_options_are_loaded
        click_this_is_a_private_computer
      end

      private

      def wait_until_options_are_loaded
        page.find(this_is_a_private_computer_id, visible: false)
      end

      def click_this_is_a_private_computer
        click_id(this_is_a_private_computer_id)
      end

      def this_is_a_private_computer_id
        "#radioGroup_No"
      end
    end
  end
end
