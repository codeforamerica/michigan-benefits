module MiBridges
  class Driver
    class PrivacyPinPage < FillInAndClickNextPage
      def self.title
        "Privacy PIN"
      end

      def fill_in_required_fields
        click_id(this_is_a_private_computer_id)
      end

      private

      def this_is_a_private_computer_id
        "#radioGroup_No"
      end
    end
  end
end
