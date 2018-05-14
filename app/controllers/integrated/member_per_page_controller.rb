module Integrated
  class MemberPerPageController < FormsController
    helper_method :current_member
    helper_method :member_appropriate_translation_data

    def update_models
      current_member.update(member_params)
    end

    def current_member
      @_current_member ||= member_from_querystring || member_from_form || first_member
    end

    def next_path
      next_member_path || super
    end

    def previous_path(*)
      previous_member_path || super
    end

    def member_appropriate_translation_data
      {
        count: current_application.primary_member == current_member ? 0 : 1,
        name: current_member.display_name(first_only: true),
      }
    end

    private

    # Override methods below

    def set_default_values; end

    def member_scope
      current_application.members
    end

    # Don't override methods below

    def first_member
      member_scope.
        limit(1).
        first
    end

    def next_member_path
      return if next_member.nil?

      section_path(self.class.to_param, params: { member: next_member.id })
    end

    def previous_member_path
      return if previous_member.nil?

      section_path(self.class.to_param, params: { member: previous_member.id })
    end

    def existing_attributes
      set_default_values
      HashWithIndifferentAccess.new(current_member.attributes)
    end

    def member_from_form
      @_member_from_form ||= current_application.
        members.
        where(id: form_params[:id]).
        first
    end

    def member_from_querystring
      return if params[:member].blank?

      current_application.members.find(params[:member])
    end

    def next_member
      current_member = member_from_form ||
        member_from_querystring ||
        first_member

      return if current_member.nil?

      member_scope.
        after(current_member).
        first
    end

    def previous_member
      current_member = member_from_form ||
        member_from_querystring ||
        first_member

      return if current_member.nil?

      member_scope.
        before(current_member).
        last
    end
  end
end
