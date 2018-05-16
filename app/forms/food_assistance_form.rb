class FoodAssistanceForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :requesting_food
end
