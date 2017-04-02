class Views::Navs::Show < Views::Base
  def content
    content_for :header_title, "Nav"

    div class: "slab" do
      Nav.sections.each do |section, steps|
        h3 section

        steps.each do |step|
          div do
            link_to step.subhead, step_path(step.to_param), class: "button button--small button--full-width"
          end
        end
      end
    end
  end
end
