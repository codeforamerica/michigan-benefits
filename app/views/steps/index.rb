# frozen_string_literal: true

class Views::Steps::Index < Views::Base
  def content
    content_for :header_title, 'Navigation'

    div class: 'slab' do
      StepNavigation.sections.each do |section, steps|
        h3 section

        steps.each do |step|
          div do
            link_to step.to_param.titleize,
              step_path(step),
              class: 'button button--small button--full-width'
          end
        end
      end
    end
  end
end
