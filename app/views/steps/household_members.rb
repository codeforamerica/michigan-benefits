class Views::Steps::HouseholdMembers < Views::Base
  needs :app

  def content
    slab_with_card do
      div do
        div class: "button buttonish button--full-width" do
          i class: "button__icon--left icon-check--color"
          text app.applicant.name(for_header: true)
        end
      end
      app.non_applicant_members.each do |member|
        div do
          path = step_path(HouseholdAddMember.to_param, member_id: member.to_param)
          link_to path, class: "button button--full-width" do
            i class: "button__icon--left icon-check--color"
            text member.name
          end
        end
      end

      link_to step_path(HouseholdAddMember.to_param), class: "button button--full-width" do
        i class: "button__icon--left icon-add"
        text "Add a member"
      end
    end
  end
end
