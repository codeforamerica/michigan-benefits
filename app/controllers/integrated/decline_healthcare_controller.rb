module Integrated
  class DeclineHealthcareController < FormsController
    def self.skip?(application)
      application.healthcare_applying_members.count.positive?
    end

    def update
      flash[:notice] = "Please select 'Apply for FAP'"
      session[:current_application_id] = nil
      redirect_to(root_path)
    end

    def form_class
      NullStep
    end
  end
end
