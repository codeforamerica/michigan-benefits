require "rails_helper"

RSpec.describe IncomeSourcesDetailsForm do
  describe "validations" do
    xit "requires some attribute" do
      form = IncomeSourcesDetailsForm.new

      expect(form).not_to be_valid
      expect(form.errors[:some_attribute]).to be_present
    end
  end
end
