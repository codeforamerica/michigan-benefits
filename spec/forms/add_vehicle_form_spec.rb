require "rails_helper"

RSpec.describe AddVehicleForm do
  describe "validations" do
    let(:member) do
      create(:household_member)
    end

    context "valid" do
      it "is valid with all required inputs and doesn't need year_make_model" do
        form = AddVehicleForm.new(
          vehicle_type: "motorcycle",
          member_ids: [member.id.to_s],
          valid_members: [member],
        )

        expect(form).to be_valid
        expect(form.errors[:year_make_model]).to_not be_present
      end
    end

    context "invalid" do
      it "requires vehicle_type" do
        form = AddVehicleForm.new(
          member_ids: [member.id.to_s],
          valid_members: [member],
        )

        expect(form).not_to be_valid
        expect(form.errors[:vehicle_type]).to be_present
      end

      it "requires member_ids" do
        form = AddVehicleForm.new(
          vehicle_type: "motorcycle",
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end

      it "requires all member_ids to belong to valid_members" do
        invalid_member = create(:household_member)

        form = AddVehicleForm.new(
          vehicle_type: "motorcycle",
          member_ids: [member.id.to_s, invalid_member.id.to_s],
          valid_members: [member],
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end
    end
  end
end
