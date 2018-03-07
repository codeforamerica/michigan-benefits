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
      context "but my birthday is nil" do
        it "something" do
          member_one = build(:household_member,
            first_name: "anne",
            last_name: "mcDog",
            birthday: nil)
          member_two = build(:household_member,
            first_name: "Anne",
            last_name: "McDog",
            birthday: Date.new(1990, 3, 14))
          create(
            :common_application,
            members: [member_one, member_two],
          )
          create(
            :common_application,
            members: [member_one, member_two],
          )

          expect(member_one.display_name).to eq("Anne McDog")
          expect(member_two.display_name).to eq("Anne McDog (3/14/1990)")
        end
      end
    end
  end

  describe "#relationship_label" do
    it "returns '' on  unknown_relation" do
      member = build(:household_member, relationship: "unknown_relation")
      expect(member.relationship_label).to eq("")
    end

    it "returns 'You' on primary" do
      member = build(:household_member, relationship: "primary")
      expect(member.relationship_label).to eq("You")
    end

    it "returns 'Other' on other_relation" do
      member = build(:household_member, relationship: "other_relation")
      expect(member.relationship_label).to eq("Other")
    end

    it "returns 'Spouse' on spouse" do
      member = build(:household_member, relationship: "spouse")
      expect(member.relationship_label).to eq("Spouse")
    end
  end
end
