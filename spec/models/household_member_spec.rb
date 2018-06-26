require "rails_helper"

RSpec.describe HouseholdMember do
  describe "scopes" do
    describe ".pregnant" do
      it "returns members with pregnant 'yes'" do
        pregnant_member = build(:household_member, pregnant: "yes")
        members = [
          pregnant_member,
          build(:household_member, pregnant: "no"),
          build(:household_member),
        ]

        members.map(&:save)

        expect(HouseholdMember.pregnant.count).to eq(1)
        expect(HouseholdMember.pregnant.first).to eq(pregnant_member)
      end
    end

    describe ".employed" do
      it "returns members with one or more employments" do
        employed_member = build(:household_member, employments: build_list(:employment, 2))
        members = [
          employed_member,
          build(:household_member, employments: []),
        ]

        members.map(&:save)

        expect(HouseholdMember.employed.count).to eq(1)
        expect(HouseholdMember.employed.first).to eq(employed_member)
      end
    end

    describe ".self_employed" do
      it "returns members who are self-employed" do
        employed_member = build(:household_member, self_employed: "yes")
        members = [
          employed_member,
          build(:household_member, self_employed: "no"),
        ]

        members.map(&:save)

        expect(HouseholdMember.self_employed.count).to eq(1)
        expect(HouseholdMember.self_employed.first).to eq(employed_member)
      end
    end

    describe ".with_additional_income" do
      it "returns members who have additional income sources" do
        member = build(:household_member, additional_incomes: build_list(:additional_income, 1))
        members = [member, build(:household_member)]
        members.map(&:save)

        expect(HouseholdMember.with_additional_income.count).to eq(1)
        expect(HouseholdMember.with_additional_income.first).to eq(member)
      end
    end

    describe ".requesting_food" do
      it "returns members who are applying for food" do
        food_members = [
          create(:household_member, :requesting_food),
        ]
        create(:household_member)

        expect(HouseholdMember.requesting_food).to match_array(food_members)
      end
    end

    describe ".requesting_healthcare" do
      it "returns members who are applying for healthcare" do
        healthcare_members = [
          create(:household_member, :requesting_healthcare),
        ]
        create(:household_member)

        expect(HouseholdMember.requesting_healthcare).to match_array(healthcare_members)
      end
    end
  end

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

      context "when first_only is true" do
        it "only provides the first name" do
          member_one = build(:household_member, first_name: "anne", last_name: "mcDog")
          member_two = build(:household_member, first_name: "sophie", last_name: "grey")
          create(
            :common_application,
            members: [member_one, member_two],
          )

          expect(member_one.display_name(first_only: true)).to eq("Anne")
          expect(member_two.display_name(first_only: true)).to eq("Sophie")
        end
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
        expect(member_one.display_name(first_only: true)).to eq("Anne McDog")
        expect(member_two.display_name(first_only: true)).to eq("Anne Grey")
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
        expect(member_one.display_name(first_only: true)).to eq("Anne McDog (1/2/1980)")
        expect(member_two.display_name(first_only: true)).to eq("Anne McDog (3/14/1990)")
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
          expect(member_one.display_name(first_only: true)).to eq("Anne McDog")
          expect(member_two.display_name(first_only: true)).to eq("Anne McDog (3/14/1990)")
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

  describe "#age" do
    it "returns nil if no birthday is set" do
      member = build(:household_member)
      expect(member.age).to be_nil
    end

    it "returns the member's age" do
      time = Time.utc(2008, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        member = build(
          :member,
          first_name: "Lala",
          birthday: DateTime.parse("June 20, 1990"),
        )

        expect(member.age).to eq 17
      end
    end
  end
end
