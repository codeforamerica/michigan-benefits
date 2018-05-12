class Form
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names

  def assign_attribute(name, value)
    assign_attributes(name => value)
  end

  class <<self
    def set_application_attributes(*application_attributes)
      @application_attributes = application_attributes
      form_attributes(application_attributes)
    end

    def set_member_attributes(*member_attributes)
      @member_attributes = member_attributes
      form_attributes(member_attributes)
    end

    def set_navigator_attributes(*navigator_attributes)
      @navigator_attributes = navigator_attributes
      form_attributes(navigator_attributes)
    end

    def set_employment_attributes(*employment_attributes)
      @employment_attributes = employment_attributes
      form_attributes(employment_attributes)
    end

    def set_address_attributes(*address_attributes)
      @address_attributes = address_attributes
      form_attributes(address_attributes)
    end

    def application_attributes
      @application_attributes || []
    end

    def member_attributes
      @member_attributes || []
    end

    def navigator_attributes
      @navigator_attributes || []
    end

    def employment_attributes
      @employment_attributes || []
    end

    def address_attributes
      @address_attributes || []
    end

    private

    def form_attributes(attribute_names)
      attributes = (application_attributes +
        member_attributes +
        navigator_attributes +
        employment_attributes +
        address_attributes)
      self.attribute_names = attributes

      attribute_strings = Step::Attributes.
        new(attribute_names).
        to_s

      attr_accessor(*attribute_strings)
    end
  end
end
