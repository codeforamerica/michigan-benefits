module Integrated
  class AddVehicleController < FormsController
    def previous_path(*args)
      overview_path(*args)
    end

    def next_path
      overview_path
    end

    def overview_path(*args)
      vehicles_overview_sections_path(*args)
    end

    helper_method :members

    def members
      current_application.members
    end

    private

    def assign_attributes_to_form
      @form = form_class.new(form_params.merge(valid_members: members))
    end

    def update_models
      Vehicle.create!(params_for(:vehicle))
    end
  end
end
