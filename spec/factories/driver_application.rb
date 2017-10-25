FactoryBot.define do
  factory :driver_application do
    user_id "JohnDoe"
    password "password"
    secret_question_1_answer "Answer 1"
    secret_question_2_answer "Answer 2"
    driven_at DateTime.current

    snap_application
  end
end
