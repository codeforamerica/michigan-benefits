module SkipRules
  def self.single_member_only(application)
    true unless application.single_member_household?
  end

  def self.multi_member_only(application)
    true if application.single_member_household?
  end

  def self.must_be_applying_for_healthcare(application)
    true unless application.applying_for_healthcare?
  end

  def self.must_not_be_applying_for_healthcare(application)
    true if application.applying_for_healthcare?
  end
end
