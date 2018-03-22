module Integrated
  class AddMemberController < FormsController
    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def form_class
      AddMemberForm
    end
  end
end
