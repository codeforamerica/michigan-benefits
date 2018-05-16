class HowManyBabiesForm < Form
  set_attributes_for :member,
                     :id, :baby_count

  validates_numericality_of :baby_count,
    greater_than: 0,
    message: "Make sure to add at least one baby."
end
