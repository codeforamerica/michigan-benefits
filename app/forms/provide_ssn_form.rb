class ProvideSsnForm < Form
  extend AutoStripAttributes
  include StepSocialSecurityNumber

  set_attributes_for :member, :ssn
end
