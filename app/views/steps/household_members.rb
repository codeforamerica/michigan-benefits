class Views::Steps::HouseholdMembers < Views::Base
  needs :app

  def content
    slab_with_card do
      div do
        div "#{app.applicant.reflected_name}", class: "button buttonish button--full-width"
      end
      app.non_applicant_members.each do |member|
        div do
          link_to member.reflected_name,
            step_path(HouseholdAddMember.to_param, member_id: member.to_param),
            class: "button button--full-width"
        end
      end

      link_to "Add a household member",
        step_path(HouseholdAddMember.to_param),
        class: "button button--cta button--full-width"
    end
  end
end
