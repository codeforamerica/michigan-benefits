# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentTypeController < MedicaidStepsController
    helper_method :current_member

    def update
      @step = step_class.new(step_params)

      if @step.valid?
        current_member.update(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    def current_member
      @_current_member ||= begin
                             member_from_form ||
                               member_from_querystring ||
                               first_insurance_holder
                           end
    end

    private

    def next_path
      next_member_path || super
    end

    def next_member_path
      return if next_member.nil?

      decoded_step_path(params: { member: next_member.id })
    end

    def first_insurance_holder
      current_application.
        members.
        first_insurance_holder
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        where(insured: true).
        where("created_at > ?", current_member.created_at).
        order(created_at: :asc).
        limit(1).
        first
    end

    def skip?
      current_application.nobody_insured?
    end

    def member_attrs
      %i[insurance_type]
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_member&.attributes)
    end

    def member_from_form
      return if params.dig(:step, :member_id).blank?

      member_id = params[:step].delete(:member_id)
      current_application.members.find(member_id)
    end

    def member_from_querystring
      return if params[:member].blank?

      current_application.members.find(params[:member])
    end
  end
end
