class HouseholdRemoveMemberController < SnapStepsController
  helper_method :member_id

  def update
    if current_application.members.delete(member)
      redirect_to next_path
    else
      redirect_to :back
    end
  end

  private

  def member
    @member ||= find_member
  end

  def find_member
    household_members = current_application.members

    if member_id.present?
      household_members.find_by(id: member_id)
    end
  end

  def member_id
    @member_id ||= params[:member_id]
  end
end
