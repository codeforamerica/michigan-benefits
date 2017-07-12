# frozen_string_literal: true

class HouseholdAddMemberController < SimpleStepController
  def edit
    @step = step_class.new(member.attributes.slice(*step_attrs))
  end

  def update
    member.update!(step_params)
    redirect_to next_path
  end

  private

  def member
    household_members = current_app.household_members
    member_id.present? ?
      household_members.find_by(id: member_id) :
      household_members.build
  end

  def member_id
    @member_id ||= params[:member_id]
  end
end
