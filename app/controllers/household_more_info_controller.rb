class HouseholdMoreInfoController < SnapStepsController
  private

  def update_application
    super

    if single_member_household?
      current_application.primary_member.update!(member_attrs)
    else
      current_application.members.each do |member|
        member.update!(multi_member_attrs)
      end
    end
  end

  def member_attrs
    {
      citizen: step_params[:everyone_a_citizen],
      disabled: step_params[:anyone_disabled],
      new_mom: step_params[:anyone_new_mom],
      in_college: step_params[:anyone_in_college],
      living_elsewhere: step_params[:anyone_living_elsewhere],
    }
  end

  def multi_member_attrs
    construct_positive_attributes("citizen").
      merge(construct_negative_attributes("disabled")).
      merge(construct_negative_attributes("new_mom")).
      merge(construct_negative_attributes("in_college")).
      merge(construct_negative_attributes("living_elsewhere"))
  end

  def construct_positive_attributes(key)
    construct_attributes("everyone_a_#{key}", key, "true")
  end

  def construct_negative_attributes(key)
    construct_attributes("anyone_#{key}", key, "false")
  end

  def construct_attributes(application_attr, member_attr, value)
    if step_params[application_attr.to_sym] == value
      { member_attr.to_sym => step_params[application_attr.to_sym] }
    else
      {}
    end
  end
end
