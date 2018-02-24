class MemberStepsController < SnapStepsController
  include PerMemberControllerMixin

  helper_method :current_member
end
