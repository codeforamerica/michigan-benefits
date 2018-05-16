class HowManyJobsForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :employments_count
end
