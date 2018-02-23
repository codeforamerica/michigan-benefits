class MemberStepsController < SnapStepsController
  include PerMemberControllerMixin

  helper_method :current_member
  helper_method :you_or_member_display
end
