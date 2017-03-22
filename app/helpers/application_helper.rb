module ApplicationHelper
  def path_to_step(step_or_path)
    if step_or_path.is_a? Step
      step_path(step_or_path.to_param)
    else
      step_or_path
    end
  end
end
