# frozen_string_literal: true

class Views::Shared::Footer < Views::Base
  def content
    div class: 'main-footer' do
      p <<~TEXT, class: 'text--small'
        This site hosts a multi-benefit application and enrollment prototype, delivered by Code for
        America and Civilla.
      TEXT

      p <<~TEXT, class: 'text--small'
        This prototype has been designed to model how to create simpler, more user-centered
        application experience in Michigan.
      TEXT

      p <<~TEXT, class: 'text--small'
        This is a template that MDHHS can customize for its enrollment programs.
      TEXT

      div class: 'illustration illustration--cfa'
      div class: 'illustration illustration--civilla'
    end
  end
end
