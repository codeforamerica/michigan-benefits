# frozen_string_literal: true

module StepsHelper
  def icon(name)
    content_tag(
      :div,
      class: "step-section-header__icon.illustration.illustration--#{name}",
    )
  end

  def data_md5(str)
    Digest::MD5.hexdigest(str ? str.squish : "")
  end

  def header_name(household_member)
    name = household_member.first_name.titleize
    household_member.primary_member? ? "#{name} (that’s you!)" : name
  end
end
