require "rails_helper"

RSpec.describe Integrated::RemoveVehicleController do
  describe "#update" do
    it "removes vehicle from the application" do
      vehicle_one = create(:vehicle)
      vehicle_two = create(:vehicle)
      current_app = create(:common_application,
        members: [create(:household_member, vehicles: [vehicle_one, vehicle_two])])

      session[:current_application_id] = current_app.id

      expect do
        put :update, params: { form: { vehicle_id: vehicle_two.id } }
      end.to change { current_app.vehicles.count }.by(-1)
    end
  end
end
