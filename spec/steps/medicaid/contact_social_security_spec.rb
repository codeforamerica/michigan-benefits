require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurity do
  let(:subject) do
    Medicaid::ContactSocialSecurity.new(birthday: 20.years.ago)
  end

  include_examples "social security number"
end
