module MiBridges
  class Driver
    module Services
      class DriverApplicationFactory
        MAXIMUM_SECRET_QUESTION_ANSWER_CHAR_COUNT = 20
        MAXIMUM_USER_ID_CHAR_COUNT = 20
        MAXIMUM_PASSWORD_CHAR_COUNT = 16

        def initialize(snap_application:)
          @snap_application = snap_application
        end

        def run
          snap_application.driver_applications.create(
            user_id: generate_user_id,
            password: generate_password,
            secret_question_1_answer: generate_secret_question_1_answer,
            secret_question_2_answer: generate_secret_question_2_answer,
            driven_at: DateTime.current,
          )
        end

        private

        attr_reader :snap_application

        def generate_user_id
          SecureRandom.hex(MAXIMUM_USER_ID_CHAR_COUNT / 2)
        end

        def generate_password
          SecureRandom.hex(MAXIMUM_PASSWORD_CHAR_COUNT / 2)
        end

        def generate_secret_question_1_answer
          SecureRandom.hex(MAXIMUM_SECRET_QUESTION_ANSWER_CHAR_COUNT / 2)
        end

        def generate_secret_question_2_answer
          SecureRandom.hex(MAXIMUM_SECRET_QUESTION_ANSWER_CHAR_COUNT / 2)
        end
      end
    end
  end
end
