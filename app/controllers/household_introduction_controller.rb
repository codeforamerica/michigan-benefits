class HouseholdIntroductionController < SimpleStepController
  def edit
  end

  def update
    redirect_to next_path
  end
end
