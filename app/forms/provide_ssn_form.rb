class ProvideSsnForm < Form
  extend AutoStripAttributes
  include StepSocialSecurityNumber

  set_member_attributes(:ssn)
end
