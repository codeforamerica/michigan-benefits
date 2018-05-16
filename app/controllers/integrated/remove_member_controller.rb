module Integrated
  class RemoveMemberController < FormsController
    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def member
      if params_for(:member)[:member_id].present?
        current_application.members.find_by(id: params_for(:member)[:member_id])
      end
    end

    def form_class
      RemoveMemberForm
    end
  end
end
