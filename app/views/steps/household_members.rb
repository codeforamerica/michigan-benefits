class Views::Steps::HouseholdMembers < Views::Base
  needs :app

  def content
    slab_with_card do
      app.household_members.each do |member|
        div do
          link_to member.full_name, step_path(AddHouseholdMember.to_param, member_id: member.to_param), class: "button button--full-width"
        end
      end
      link_to "Add a household member", step_path(AddHouseholdMember.to_param), class: "button button--cta button--full-width"
    end
  end
end
