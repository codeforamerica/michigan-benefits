module MiBridges
  class Driver
    class MultiFactorAuthPage < FillInAndClickNextPage
      def fill_in_required_fields
        click_id(security_question_radio_button)
      end

      private

      def security_question_radio_button
        "#radioGroup_Security_Questions"
      end
    end
  end
end
