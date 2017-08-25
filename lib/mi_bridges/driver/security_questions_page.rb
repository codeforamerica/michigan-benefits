# frozen_string_literal: true

module MiBridges
  class Driver
    class SecurityQuestionsPage < BasePage
      def setup; end

      def fill_in_required_fields
        fill_in "Answer to Secret Question1:", with: answer_1
        fill_in "Answer to Secret Question2:", with: answer_2
      end

      def continue
        click_on "Next"
      end

      private

      def answer_1
        current_application.secret_question_1_answer
      end

      def answer_2
        current_application.secret_question_2_answer
      end

      def current_application
        snap_application.driver_application
      end
    end
  end
end
