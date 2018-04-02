module Integrated
  class WereYouFosterCareController < FormsController
    def self.skip?(application)
      return true unless application.single_member_household?
      if age = application.primary_member.age
        return age >= 18 && age <= 26 ? false : true
      end
      true
    end

    def update_models
      current_application.primary_member.update!(member_params)
    end
  end
end
