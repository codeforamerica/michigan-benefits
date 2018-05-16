module Integrated
  class MultipleMembersPerPageController < FormsController
    def edit
      @form = form_class.new(members: members_to_update)
    end

    def update
      @form = form_class.new(members: members_to_update)
      @form.members.each do |member|
        attrs = params.dig(:form, :members, member.to_param)
        if attrs.present?
          member.assign_attributes(attrs.permit(form_class.attributes_for(:member)))
        end
      end

      if @form.valid?
        ActiveRecord::Base.transaction { @form.members.each(&:save!) }
        redirect_to next_path
      else
        render :edit
      end
    end

    private

    def members_to_update
      current_application.members
    end
  end
end
