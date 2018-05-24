require "rails_helper"

RSpec.describe Vehicle do
  describe ".members" do
    it "orders members by created_at" do
      member1 = create(:household_member)
      member2 = Timecop.freeze(1.hour.ago) do
        create(:household_member)
      end
      vehicle = create(:vehicle, members: [member1, member2])

      vehicle.reload

      expect(vehicle.members.first).to eq(member2)
      expect(vehicle.members.last).to eq(member1)
    end
  end

  describe "validations" do
    context "when vehicle type is a permitted type" do
      it "is valid" do
        vehicle = build(:vehicle, vehicle_type: "other")

        expect(vehicle.valid?).to be_truthy
      end
    end

    context "when vehicle type not in permitted types" do
      it "is invalid" do
        vehicle = build(:vehicle, vehicle_type: "foo")

        expect(vehicle.valid?).to be_falsey
      end
    end

    context "when vehicle type not included" do
      it "is invalid" do
        vehicle = build(:vehicle, vehicle_type: nil)

        expect(vehicle.valid?).to be_falsey
      end
    end
  end

  describe "#display_name_and_make" do
    context "year_model_make is empty" do
      it "only returns the type" do
        vehicle = build(:vehicle, vehicle_type: "other")

        expect(vehicle.display_name_and_make).to eq("Other vehicle")
      end
    end

    context "year_make_model has a value" do
      it "formats type and make together" do
        vehicle = build(:vehicle, vehicle_type: "other", year_make_model: "1800 Fulton Nautilus Submarine")

        expect(vehicle.display_name_and_make).to eq("Other vehicle: 1800 Fulton Nautilus Submarine")
      end
    end
  end
end
