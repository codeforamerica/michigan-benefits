module Integrated
  class BuyAndPrepareFoodSeparatelyController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      application.navigator.all_share_food_costs?
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
      @_members ||= current_application.food_applying_members - [current_application.primary_member]
    end

    def form_params
      params.fetch(:form, {}).permit(members: {})
    end
  end
end
