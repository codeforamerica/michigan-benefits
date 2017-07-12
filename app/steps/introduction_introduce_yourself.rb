class IntroductionIntroduceYourself < SimpleStep
  step_attributes :first_name, :last_name

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }
end
