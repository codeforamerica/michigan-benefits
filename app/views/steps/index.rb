class Views::Steps::Index < Views::Base
  def content
    content_for :header_title, "Navigation"

    div class: "slab" do
      StepNavigation.sections.each do |section, steps|
        h3 section

        steps.each do |step|
          tag = step < SimpleStepController ? " (refactored)" : ""

          div do
            link_to "#{step.name} #{tag}",
              step_path(step.to_param),
              class: "button button--small button--full-width"
          end
        end
      end
    end
  end
end
