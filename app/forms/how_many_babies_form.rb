class HowManyBabiesForm < Form
  set_member_attributes(:id, :baby_count)

  validates_numericality_of :baby_count,
    greater_than: 0,
    message: "Make sure to add at least one baby."
end
