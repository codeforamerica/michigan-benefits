module ApplicationHelper
  def template_name_css_class
    return unless content_for?(:template_name)

    "template--#{content_for(:template_name)}"
  end

  def debug?
    ENV["DEBUG"] == "true"
  end

  def full_office_name(application)
    if application.receiving_office_name == "Clio"
      "Clio Road"
    elsif application.receiving_office_name == "Union"
      "Union Street"
    else
      "MDHHS"
    end
  end

  def tooltip_title(text)
    "title=\"#{text}\"".html_safe if GateKeeper.feature_enabled?("ANNOTATIONS")
  end
end
