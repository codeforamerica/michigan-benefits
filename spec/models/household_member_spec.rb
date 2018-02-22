require "rails_helper"

RSpec.describe HouseholdMember do
  describe "#display_name" do
    it "only generates the display name once" do
      member = build(:household_member)
      create(
        :common_application,
        members: [member],
      )

      expect(member.display_name).to be(member.display_name)
    end

    context "I have a unique first and last name for my household" do
      it "combines first name and last name" do
        member_one = build(:household_member, first_name: "anne", last_name: "mcDog")
        member_two = build(:household_member, first_name: "sophie", last_name: "grey")
        create(
          :common_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog")
        expect(member_two.display_name).to eq("Sophie Grey")
      end
    end

    context "I have same first name but different last name than someone my household" do
      it "combines first name and last name" do
        member_one = build(:household_member, first_name: "anne", last_name: "mcDog")
        member_two = build(:household_member, first_name: "anne", last_name: "grey")
        create(
          :common_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog")
        expect(member_two.display_name).to eq("Anne Grey")
      end
    end

    context "I have same first and last name as someone in my household" do
      it "combines first name and last name, plus date of birth" do
        member_one = build(:household_member,
                           first_name: "anne",
                           last_name: "mcDog",
                           birthday: Date.new(1980, 1, 2))
        member_two = build(:household_member,
                           first_name: "Anne",
                           last_name: "McDog",
                           birthday: Date.new(1990, 3, 14))
        create(
          :common_application,
          members: [member_one, member_two],
        )

        expect(member_one.display_name).to eq("Anne McDog (1/2/1980)")
        expect(member_two.display_name).to eq("Anne McDog (3/14/1990)")
      end
    end
  end
end
