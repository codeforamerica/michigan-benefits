# https://github.com/rails/rails/pull/8189#issuecomment-32803107

module MultiparameterAttributeAssignment
  include ActiveModel::ForbiddenAttributesProtection

  def initialize(params = {})
    assign_attributes(params)
  end

  def assign_attributes(new_attributes)
    multi_parameter_attributes = []

    attributes = sanitize_for_mass_assignment(new_attributes.stringify_keys)

    attributes.each do |key, value|
      if key.include?("(")
        multi_parameter_attributes << [key, value]
      else
        send("#{key}=", value)
      end
    end

    unless multi_parameter_attributes.empty?
      assign_multiparameter_attributes(multi_parameter_attributes)
    end
  end

  alias attributes= assign_attributes

  protected

  def attribute_assignment_error_class
    ActiveModel::AttributeAssignmentError
  end

  def multiparameter_assignment_errors_class
    ActiveModel::MultiparameterAssignmentErrors
  end

  def unknown_attribute_error_class
    ActiveModel::UnknownAttributeError
  end

  def assign_multiparameter_attributes(pairs)
    execute_callstack_for_multiparameter_attributes(
      extract_callstack_for_multiparameter_attributes(pairs),
    )
  end

  def execute_callstack_for_multiparameter_attributes(callstack)
    # Disabling Rubcop below because Brakeman is failing to parse the
    #  when we remove the 'begin' keyword
    # rubocop:disable Style/RedundantBegin
    errors = []

    callstack.each do |name, values_with_empty_parameters|
      begin
        unless respond_to?("#{name}=")
          raise unknown_attribute_error_class, "unknown attribute: #{name}"
        end
        send(
          "#{name}=",
          MultiparameterAttribute.new(
            self,
            name,
            values_with_empty_parameters,
          ).read_value,
        )
      rescue StandardError => ex
        values = values_with_empty_parameters.values.inspect
        errors << attribute_assignment_error_class.new(
          "error on assignment #{values} to #{name} (#{ex.message})",
          ex,
          name,
        )
      end
    end

    unless errors.empty?
      messages = errors.map(&:message).join(",")
      raise(
        multiparameter_assignment_errors_class.new(errors),
        "#{errors.size} error(s): [#{messages}]",
      )
    end
    # rubocop:enable Style/RedundantBegin
  end

  def extract_callstack_for_multiparameter_attributes(pairs)
    attributes = {}

    pairs.each do |(multiparameter_name, value)|
      attribute_name = multiparameter_name.split("(").first
      attributes[attribute_name] ||= {}

      parameter_value = if value.empty?
                          nil
                        else
                          type_cast_attribute_value(multiparameter_name, value)
                        end
      parameter_position = find_parameter_position(multiparameter_name)
      attributes[attribute_name][parameter_position] ||= parameter_value
    end

    attributes
  end

  def type_cast_attribute_value(multiparameter_name, value)
    multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_#{$1}") : value
  end

  def find_parameter_position(multiparameter_name)
    multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
  end
end

class MultiparameterAttribute
  attr_reader :object, :name, :values

  def initialize(object, name, values)
    @object = object
    @name   = name
    @values = values
  end

  def class_for_attribute
    object.class_for_attribute(name)
  end

  def read_value
    return if values.values.compact.empty?

    klass = class_for_attribute

    if klass.nil?
      raise ActiveModel::UnexpectedMultiparameterValueError,
        "Did not expect a multiparameter value for #{name}. " +
        "You may be passing the wrong value, or you need to modify " +
        "class_for_attribute so that it returns the right class for " +
        "#{name}."
    elsif klass == Time
      read_time
    elsif klass == Date
      read_date
    else
      read_other(klass)
    end
  end

  private

  def instantiate_time_object(set_values)
    Time.zone.local(*set_values)
  end

  def read_time
    validate_required_parameters!([1, 2, 3])
    return if blank_date_parameter?

    max_position = extract_max_param(6)
    set_values   = values.values_at(*(1..max_position))
    # If Time bits are not there, then default to 0
    (3..5).each { |i| set_values[i] = set_values[i].presence || 0 }
    instantiate_time_object(set_values)
  end

  def read_date
    return if blank_date_parameter?
    set_values = values.values_at(1, 2, 3)

    begin
      Date.new(*set_values)
    rescue ArgumentError # if Date.new raises an exception on an invalid date
      # we instantiate Time object and convert it back to a date thus using
      # Time's logic in handling invalid dates
      instantiate_time_object(set_values).to_date
    end
  end

  def read_other(klass)
    max_position = extract_max_param
    positions    = (1..max_position)
    validate_required_parameters!(positions)

    set_values = values.values_at(*positions)
    klass.new(*set_values)
  end

  def blank_date_parameter?
    (1..3).any? { |position| values[position].blank? }
  end

  def validate_required_parameters!(positions)
    missing_parameter = missing_parameter(positions)

    if missing_parameter
      raise ArgumentError.new(
        "Missing Parameter - #{name}(#{missing_parameter})",
      )
    end
  end

  def missing_parameter(positions)
    positions.detect { |position| !values.key?(position) }
  end

  def extract_max_param(upper_cap = 100)
    [values.keys.max, upper_cap].min
  end
end

module ActiveModel
  class AttributeAssignmentError < StandardError
    attr_reader :exception, :attribute

    def initialize(message, exception, attribute)
      super(message)
      @exception = exception
      @attribute = attribute
    end
  end
end

module ActiveModel
  class MultiparameterAssignmentErrors < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end
  end
end

module ActiveModel
  class UnexpectedMultiparameterValueError < StandardError; end
end

module ActiveModel
  class UnknownAttributeError < NoMethodError; end
end
