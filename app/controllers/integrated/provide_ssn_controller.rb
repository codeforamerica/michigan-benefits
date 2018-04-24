module Integrated
  class ProvideSsnController < FormsController
    def update_models
      current_application.primary_member.update(member_params)
    end
  end
end
