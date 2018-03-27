module Integrated
  class WhoIsMarriedController < FormsController
    def self.skip?(application)
      return true if application.single_member_household?
      return true unless application.navigator.anyone_married?
    end

    def edit
      @form = form_class.new(members: current_application.members)
    end

    def update
      @form = form_class.new(members: current_application.members)
      @form.members.each do |member|
        attrs = params.dig(:form, :members, member.to_param)
        if attrs.present?
          member.assign_attributes(attrs.permit(form_class.member_attributes))
        end
      end

      if @form.valid?
        ActiveRecord::Base.transaction { @form.members.each(&:save!) }
        redirect_to next_path
      else
        render :edit
      end
    end
  end
end
