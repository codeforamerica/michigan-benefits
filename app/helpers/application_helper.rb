# frozen_string_literal: true

module ApplicationHelper
  def template_name_css_class
    return unless content_for?(:template_name)

    "template--#{content_for(:template_name)}"
  end
end
