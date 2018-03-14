module Integrated
  class FoodAssistanceController < FormsController
    def self.skip?(current_application)
      if current_application.members.count == 1 || current_application.unstable_housing?
        ActiveRecord::Base.transaction do
          current_application.members.each { |member| member.update!(requesting_food: "yes") }
        end
        true
      else
        false
      end
    end

    def edit
      @form = form_class.new(members: members)
    end

    def update_models
      members.each do |member|
        attrs = params.dig(:form, :members, member.to_param)
        member.assign_attributes(attrs.permit(form_class.member_attributes))
      end
      ActiveRecord::Base.transaction { members.each(&:save!) }
    end

    private

    def members
      @_members ||= current_application.members
    end

    def form_params
      params.fetch(:form, {}).permit(members: {})
    end
  end
end
