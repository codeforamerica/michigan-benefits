module MiBridges
  class Driver
    class SecurityQuestionsPage < FillInAndClickNextPage
      delegate :latest_drive_attempt, to: :snap_application

      def fill_in_required_fields
        fill_in "Answer to Secret Question1:", with: answer_1
        fill_in "Answer to Secret Question2:", with: answer_2
      end

      private

      def answer_1
        latest_drive_attempt.secret_question_1_answer
      end

      def answer_2
        latest_drive_attempt.secret_question_2_answer
      end
    end
  end
end
