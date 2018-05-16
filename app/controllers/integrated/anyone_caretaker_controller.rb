module Integrated
  class AnyoneCaretakerController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
