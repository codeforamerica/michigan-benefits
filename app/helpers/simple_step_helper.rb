module SimpleStepHelper
  def back_path
    previous = StepNavigation.new(@step).previous
    previous ? step_path(previous.to_param) : root_path
  end
end
