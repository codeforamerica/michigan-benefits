module Integrated
  class BuyAndPrepareFoodWithOtherPersonController < FormsController
    def self.skip?(application)
      if application.unstable_housing? || application.snap_applying_members.count != 2
        true
      else
        false
      end
    end

    def update
      current_application.snap_applying_members.second.update(member_params)
      redirect_to(next_path)
    end
  end
end
