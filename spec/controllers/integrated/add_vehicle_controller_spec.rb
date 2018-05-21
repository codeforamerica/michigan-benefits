require "rails_helper"

RSpec.describe Integrated::AddVehicleController do
  describe "#skip?" do
    it "returns false" do
      application = create(:common_application)

      skip_step = Integrated::AddVehicleController.skip?(application)
      expect(skip_step).to eq(false)
    end
  end

  describe ".previous_path" do
    it "should be vehicles overview path" do
      expect(controller.previous_path).to eq(vehicles_overview_sections_path)
    end
  end

  describe ".next_path" do
    it "should be vehicles overview path" do
      expect(controller.next_path).to eq(vehicles_overview_sections_path)
    end
  end

  describe "#update" do
    let(:member1) do
      build(:household_member)
    end

    let(:member2) do
      build(:household_member)
    end

    context "with valid params" do
      let(:valid_params) do
        {
          member_ids: [member1.id.to_s, member2.id.to_s],
          vehicle_type: "car",
          year_make_model: "1990 Toyota Tercel",
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          members: [member1, member2] + build_list(:household_member, 2))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        expect(current_app.vehicles.count).to eq(1)
        vehicle = current_app.vehicles.first
        expect(vehicle.vehicle_type).to eq("car")
        expect(vehicle.year_make_model).to eq("1990 Toyota Tercel")
        expect(vehicle.members).to match_array([member1, member2])
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          year_make_model: "1990 Toyota Tercel",
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member1, member2] + build_list(:household_member, 2))
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(current_app.vehicles.count).to eq(0)
        expect(response).to render_template(:edit)
      end
    end
  end
end
