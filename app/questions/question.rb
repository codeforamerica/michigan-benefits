class Question
  include ActiveModel::Model
  # extend ActiveModel::Naming
  # include ActiveModel::Conversion
  # include ActiveModel::Validations

  class_attribute :title, :placeholder, :type, :model_attribute
  attr_accessor :value

  self.type = :text

  def self.find(id, app)
    id.to_s.gsub("-", "_").camelize.constantize.new(app)
  end

  def self.to_param
    self.name.underscore.dasherize
  end

  def initialize(app)
    @app = app
    self.get
  end

  def name
    self.class.name.underscore.to_sym
  end

  def get
    @app.send(model_attribute.to_sym)
  end

  def set
    new_value = if value.nil?
      nil
    elsif type == :yes_no
      value.downcase.in? %w[yes true 1]
    else
      value
    end

    @app.send("#{model_attribute.to_sym}=", new_value)
  end
end
