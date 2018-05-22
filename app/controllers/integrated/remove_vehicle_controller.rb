module Integrated
  class RemoveVehicleController < FormsController
    def update_models
      flash[:notice] = if vehicle && vehicle.destroy
                         "Removed the vehicle."
                       else
                         "Could not remove vehicle."
                       end
    end

    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def overview_path
      vehicles_overview_sections_path
    end

    def vehicle
      if params_for(:vehicle)[:vehicle_id].present?
        current_application.vehicles.find_by(id: params_for(:vehicle)[:vehicle_id])
      end
    end

    def form_class
      RemoveVehicleForm
    end
  end
end
