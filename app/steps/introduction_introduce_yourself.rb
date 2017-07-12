class IntroductionIntroduceYourself < SimpleStep
  def self.attributes
    %w[
      first_name
      last_name
    ]
  end

  attr_accessor(*attributes)

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }
end
