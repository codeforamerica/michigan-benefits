class SimpleStep
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  private

  def self.step_attributes(*attribute_names)
    self.attribute_names = attribute_names.map(&:to_s)
    attr_accessor(*attribute_names)
  end
end
