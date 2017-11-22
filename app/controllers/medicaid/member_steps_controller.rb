# frozen_string_literal: true

module Medicaid
  class MemberStepsController < MedicaidStepsController
    helper_method :current_member

    def current_member
      @_current_member ||= member_from_form || member_from_querystring
    end

    def next_path
      next_member_path || super
    end

    private

    def next_member_path
      return if next_member.nil?

      decoded_step_path(params: { member: next_member.id })
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_member.attributes)
    end

    def member_from_form
      @member_from_form ||= current_application.
        members.
        where(id: step_params[:id]).
        first
    end

    def member_from_querystring
      return if params[:member].blank?

      current_application.members.find(params[:member])
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        after(current_member).
        limit(1).
        first
    end
  end
end
