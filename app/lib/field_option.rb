# frozen_string_literal: true

module FieldOption
  extend self

  FORM_GROUP_NO_BOTTOM_SPACE = { form_group_class: 'no-bottom-space' }.freeze

  def form_group_no_bottom_space
    FORM_GROUP_NO_BOTTOM_SPACE
  end
end
