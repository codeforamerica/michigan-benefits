module Integrated
  class FoodAssistanceController < FormsController
    def self.custom_skip_rule_set(current_application)
      if current_application.single_member_household? || current_application.unstable_housing?
        ActiveRecord::Base.transaction do
          current_application.members.each do |member|
            member.update!(requesting_food: "yes", buy_and_prepare_food_together: "yes")
          end
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
        member.assign_attributes(attrs.permit(form_class.attributes_for(:member)))
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
