require "rails_helper"

RSpec.describe AnythingElseForm do
  describe "validations" do
    it "is valid when empty" do
      form = AnythingElseForm.new

      expect(form).to be_valid
      expect(form.errors[:additional_information]).not_to be_present
    end
  end
end
