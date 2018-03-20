module Integrated
  class HealthcareController < FormsController
    def self.skip?(application)
      if application.single_member_household?
        application.primary_member.update!(requesting_healthcare: "yes")
        true
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
