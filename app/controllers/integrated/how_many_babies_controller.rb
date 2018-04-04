module Integrated
  class HowManyBabiesController < FormsController
    helper_method :member_appropriate_translation_data

    def self.skip?(application)
      !application.navigator.anyone_pregnant?
    end

    def update_models
      current_member.update(member_params.slice(:baby_count))
    end

    def current_member
      @_current_member ||= member_from_querystring || first_pregnant_member
    end

    def next_path
      next_member_path || super
    end

    def member_appropriate_translation_data
      {
        count: current_application.primary_member == current_member ? 0 : 1,
        name: current_member.display_name,
      }
    end

    private

    def next_member_path
      return if next_member.nil?

      section_path(self.class.to_param, params: { member: next_member.id })
    end

    def existing_attributes
      current_member.baby_count ||= 1
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

    def first_pregnant_member
      current_application.
        members.
        pregnant.
        limit(1).
        first
    end

    def next_member
      current_member = member_from_form ||
        member_from_querystring ||
        first_pregnant_member

      return if current_member.nil?

      current_application.
        members.
        pregnant.
        after(current_member).
        limit(1).
        first
    end
  end
end
