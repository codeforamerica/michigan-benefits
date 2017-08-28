require "rails_helper"

RSpec.describe SnapApplicationExtraMemberAttributes do
  describe "#title" do
    it "returns the member's full name" do
      member = double(full_name: "BooBoo")

      title = SnapApplicationExtraMemberAttributes.new(member: member).title

      expect(title).to eq("Details for household member: BooBoo")
    end
  end

  describe "#to_a" do
    it "returns an array of attributes" do
      member = build(
        :member,
        in_college: false,
        citizen: true,
        new_mom: nil,
        marital_status: "Taken",
        birthday: DateTime.parse("June 20, 1900"),
        relationship: nil,
        requesting_food_assistance: true,
      )

      array = SnapApplicationExtraMemberAttributes.new(member: member).to_a

      expect(array).to eq(
        [
          "1. Name: #{member.full_name}",
          "2. Date of birth: 06/20/1900",
          "3. Relationship: SELF",
          "4. Sex: #{member.sex}",
          "5. Social security number: #{member.ssn}",
          "6. Marital status: Taken",
          "7. US Citizen: Yes",
          "8. Pregnant now/last 2 months: No",
          "10. In school now: No",
          "16. Type of help needed: Food",
        ],
      )
    end
  end
end
