# frozen_string_literal: true

class HouseholdAddMemberController < StandardStepsController
  helper_method :member_id

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      member.update!(step_params)
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(member_attributes)
  end

  def member_attributes
    {
      birthday: member.birthday,
      buy_food_with: member.buy_food_with,
      first_name: member.first_name,
      last_name: member.last_name,
      relationship: member.relationship,
      requesting_food_assistance: member.requesting_food_assistance,
      sex: member.sex,
      ssn: member.ssn,
    }
  end

  def member
    @member ||= find_or_initialize_member
  end

  def find_or_initialize_member
    household_members = current_snap_application.members

    if member_id.present?
      household_members.find_by(id: member_id)
    else
      household_members.build
    end
  end

  def member_id
    @member_id ||= params[:member_id]
  end
end
