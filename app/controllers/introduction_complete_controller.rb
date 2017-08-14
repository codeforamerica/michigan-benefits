# frozen_string_literal: true

class IntroductionCompleteController < StandardStepsController
  def update
    redirect_to(next_path)
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(
      current_snap_application.primary_member.attributes,
    )
  end
end
