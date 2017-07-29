# frozen_string_literal: true

module StepsHelper
  def icon(name)
    haml_tag "div.step-section-header__icon.illustration.illustration--#{name}"
  end

  def data_md5(str)
    Digest::MD5.hexdigest(str ? str.squish : "")
  end
end
