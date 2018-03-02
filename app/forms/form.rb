class Form
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  class <<self
    def set_application_attributes(*application_attributes)
      @application_attributes = application_attributes
      form_attributes(application_attributes)
    end

    def set_member_attributes(*member_attributes)
      @member_attributes = member_attributes
      form_attributes(member_attributes)
    end

    def application_attributes
      @application_attributes || []
    end

    def member_attributes
      @member_attributes || []
    end

    private

    def form_attributes(attribute_names)
      self.attribute_names = (self.application_attributes + self.member_attributes)

      attribute_strings = attribute_names.map(&:to_s)

      attr_accessor(*attribute_strings)
    end
  end
end
