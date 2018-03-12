require "rails_helper"

RSpec.describe AddHouseholdMemberForm do
  describe "validations" do
    it "requires first_name" do
      form = AddHouseholdMemberForm.new

      expect(form).not_to be_valid
      expect(form.errors[:first_name]).to be_present
    end

    it "requires last_name" do
      form = AddHouseholdMemberForm.new

      expect(form).not_to be_valid
      expect(form.errors[:last_name]).to be_present
    end

    it "does not accept invalid dates for birthday" do
      form = AddHouseholdMemberForm.new(birthday_year: 1992, birthday_month: 2, birthday_day: 30)

      expect(form).not_to be_valid
      expect(form.errors[:birthday]).to be_present
    end
  end
end
