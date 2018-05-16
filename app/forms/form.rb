class Form
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  def assign_attribute(name, value)
    assign_attributes(name => value)
  end

  class << self
    def set_attributes_for(model, *attributes)
      scoped_attributes[model] = attributes
      self.attribute_names = scoped_attributes.values.flatten
      attribute_strings = Step::Attributes.new(attributes).to_s

      attr_accessor(*attribute_strings)
    end

    def scoped_attributes
      @scoped_attributes ||= {}
    end

    def attributes_for(model)
      scoped_attributes[model] || []
    end
  end
end
