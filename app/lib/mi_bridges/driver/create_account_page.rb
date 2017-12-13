module MiBridges
  class Driver
    class CreateAccountPage < BasePage
      def self.title
        "Setting Up Your Account"
      end

      delegate :latest_drive_attempt, to: :snap_application

      def setup; end

      def fill_in_required_fields
        fill_in "First Name", with: primary_member.first_name
        fill_in "Last Name", with: primary_member.last_name

        fill_in "User ID", with: latest_drive_attempt.user_id
        fill_in "Password", with: latest_drive_attempt.password
        fill_in "Please re-type your Password",
          with: latest_drive_attempt.password

        select_secret_question_1
        fill_in "Answer to Secret Question1",
          with: latest_drive_attempt.secret_question_1_answer

        select_secret_question_2
        fill_in "Answer to Secret Question2",
          with: latest_drive_attempt.secret_question_2_answer

        accept_user_agreement
      end

      def continue
        click_on "Next"
      end

      private

      def primary_member
        @_primary_member ||= snap_application.primary_member
      end

      def select_secret_question_1
        select(
          "What was the FIRST NAME of your best friend when growing up?",
          from: "Secret Question1",
        )
      end

      def select_secret_question_2
        select(
          "Who is your favorite president?",
          from: "Secret Question2",
        )
      end

      def accept_user_agreement
        check_selector =
          "div[aria-labelledby=\"Step4UserAcceptanceAgreement\"] input"
        page.execute_script("$('#{check_selector}').click()")
      end
    end
  end
end
