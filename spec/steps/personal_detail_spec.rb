require "rails_helper"

RSpec.describe PersonalDetail do
  let(:subject) do
    PersonalDetail.new(marital_status: "Widowed", sex: "male")
  end

  include_examples "social security number"
end
