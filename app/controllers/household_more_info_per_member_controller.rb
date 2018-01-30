class HouseholdMoreInfoPerMemberController < ManyMemberStepsController
  def update
    assign_household_member_attributes

    if step.valid?
      ActiveRecord::Base.transaction { step.members.each(&:save!) }
      update_application
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def update_application
    current_application.update!(application_attrs)
  end

  def application_attrs
    {}.tap do |attributes|
      attributes[:everyone_a_citizen] = true if all_members(:citizen?)
      attributes[:anyone_disabled] = false if no_members(:disabled?)
      attributes[:anyone_new_mom] = false if no_members(:new_mom?)
      attributes[:anyone_in_college] = false if no_members(:in_college?)
      attributes[:anyone_living_elsewhere] = false if no_members(:living_elsewhere?)
    end
  end

  def all_members(attribute)
    current_application.members.all? { |m| m.public_send(attribute) }
  end

  def no_members(attribute)
    current_application.members.all? { |m| !m.public_send(attribute) }
  end

  def member_attrs
    %i[citizen disabled new_mom in_college living_elsewhere]
  end

  def skip?
    no_additional_info_needed?
  end

  def no_additional_info_needed?
    current_application.everyone_a_citizen? &&
      !current_application.anyone_disabled? &&
      !current_application.anyone_new_mom? &&
      !current_application.anyone_in_college? &&
      !current_application.anyone_living_elsewhere?
  end
end
