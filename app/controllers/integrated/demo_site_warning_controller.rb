module Integrated
  class DemoSiteWarningController < FormsController
    skip_before_action :ensure_application_present

    def self.skip?(_application)
      !GateKeeper.demo_environment?
    end

    def form_class
      NullStep
    end
  end
end
