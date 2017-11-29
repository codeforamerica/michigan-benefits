module Medicaid
  class SuccessController < MedicaidStepsController
    def edit
      super

      export
    end

    def previous_path(*_args)
      nil
    end

    private

    def export
      Medicaid::ExportFactory.create(
        destination: :office_email,
        benefit_application: current_application,
      )
    end

    def step_class
      NullStep
    end
  end
end
