class HealthcareForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :requesting_healthcare
end
