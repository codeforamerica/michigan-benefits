class Step
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  def self.step_attributes(*attribute_names)
    self.attribute_names = attribute_names

    attribute_strings = Step::Attributes.
      new(attribute_names).
      to_s

    attr_accessor(*attribute_strings)
  end

  def hash_key_attribute?(attribute)
    Step::Attributes.
      new(self.class.attribute_names).
      hash_key?(attribute)
  end
end
