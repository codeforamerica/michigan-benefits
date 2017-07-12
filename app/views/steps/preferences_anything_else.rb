# frozen_string_literal: true

class Views::Steps::PreferencesAnythingElse < Views::Base
  needs :f

  def content
    slab_with_card do
      question f, :anything_else, nil do
        text_area_field f, :anything_else, 'Write here'
      end
    end
  end
end
