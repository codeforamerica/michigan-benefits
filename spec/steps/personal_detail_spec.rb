require "rails_helper"

RSpec.describe PersonalDetail do
  let(:subject) do
    PersonalDetail.new(marital_status: "Widowed", sex: "male")
  end

  it_should_behave_like "social security number"
end
