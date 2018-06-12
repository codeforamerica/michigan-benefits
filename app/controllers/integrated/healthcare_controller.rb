module Integrated
  class HealthcareController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application)
      ]
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
