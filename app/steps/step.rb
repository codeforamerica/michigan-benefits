class Step
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  class <<self
    def step_attributes(*attribute_names)
      self.attribute_names = attribute_names

      attribute_strings = Step::Attributes.
        new(attribute_names).
        to_s

      attr_accessor(*attribute_strings)
    end
  end
end
