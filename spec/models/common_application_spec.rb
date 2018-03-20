require "rails_helper"

RSpec.describe CommonApplication do
  describe "scopes" do
    describe ".snap_household_members" do
      it "returns members applying for food assistance who buy and prepare food together" do
        in_household = build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "yes")

        application = create(:common_application,
          members: [
            in_household,
            build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "no"),
            build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "unfilled"),
            build(:household_member, requesting_food: "no", buy_and_prepare_food_together: "yes"),
            build(:household_member, requesting_food: "unfilled", buy_and_prepare_food_together: "yes"),
          ])

        expect(application.snap_household_members.count).to eq(1)
        expect(application.snap_household_members.first).to eq(in_household)
      end

      it "orders by time created at" do
        second_member = build(:household_member, :in_snap_household, created_at: Time.now)
        first_member = build(:household_member, :in_snap_household, created_at: Time.now - 1.day)

        application = create(:common_application, members: [
                               second_member,
                               first_member,
                             ])

        expect(application.snap_household_members.first).to eq(first_member)
        expect(application.snap_household_members.second).to eq(second_member)
      end
    end

    describe ".snap_applying_members" do
      it "returns all members requesting food assistance" do
        in_household = build(:household_member, requesting_food: "yes")

        application = create(:common_application,
          members: [
            in_household,
            build(:household_member, requesting_food: "no"),
            build(:household_member),
          ])

        expect(application.snap_applying_members.count).to eq(1)
        expect(application.snap_applying_members.first).to eq(in_household)
      end
    end

    describe ".healthcare_applying_members" do
      it "returns all members requesting food assistance" do
        in_household = build(:household_member, requesting_healthcare: "yes")

        application = create(:common_application,
          members: [
            in_household,
            build(:household_member, requesting_healthcare: "no"),
            build(:household_member),
          ])

        expect(application.healthcare_applying_members.count).to eq(1)
        expect(application.healthcare_applying_members.first).to eq(in_household)
      end
    end
  end

  describe "#single_member_household?" do
    context "when one member in household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        expect(application.single_member_household?).to be_truthy
      end
    end

    context "when more than one member in household" do
      it "returns false" do
        application = create(:common_application, :multi_member)

        expect(application.single_member_household?).to be_falsey
      end
    end

    context "when zero members in household" do
      it "returns false" do
        application = create(:common_application)

        expect(application.single_member_household?).to be_falsey
      end
    end
  end

  describe "#unstable_housing?" do
    context "with stable housing" do
      it "returns false" do
        application = build(:common_application, living_situation: "stable_address")
        expect(application.unstable_housing?).to eq(false)
      end
    end

    context "when homeless" do
      it "returns true" do
        application = build(:common_application, living_situation: "homeless")
        expect(application.unstable_housing?).to eq(true)
      end
    end

    context "with temporary housing" do
      it "returns true" do
        application = build(:common_application, living_situation: "temporary_address")
        expect(application.unstable_housing?).to eq(true)
      end
    end

    context "when not answered" do
      it "returns false" do
        application = build(:common_application)
        expect(application.unstable_housing?).to eq(false)
      end
    end
  end

  describe "#applying_for_food_assistance?" do
    it "returns true when at least one household member is" do
      application = create(:common_application,
                           members: [create(:household_member, requesting_food: "yes")])
      expect(application.applying_for_food_assistance?).to be_truthy
    end

    it "returns false when no one is" do
      application = create(:common_application,
                           members: [create(:household_member, requesting_food: "no")])
      expect(application.applying_for_food_assistance?).to be_falsey
    end
  end
end
