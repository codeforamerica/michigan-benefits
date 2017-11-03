class Step
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  def self.step_attributes(*attribute_names)
    self.attribute_names = attribute_names

    attributes_or_keys = attribute_names.map do |attr|
      if attr.class == Symbol
        attr
      else
        attr.keys
      end
    end

    attr_accessor(*attributes_or_keys.flatten.map(&:to_s))
  end
end
