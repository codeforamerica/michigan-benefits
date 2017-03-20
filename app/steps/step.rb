class Step
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment

  class_attribute :title, :headline, :subhead, :questions, :placeholders, :types

  def self.first
    IntroduceYourself
  end

  def self.find(id, app)
    id.gsub("-", "_").camelize.constantize.new(app)
  end

  def self.to_param
    self.name.underscore.dasherize
  end

  def initialize(app)
    @app = app
    assign_from_app
  end

  def to_param
    self.class.to_param
  end

  def update(params)
    assign_attributes(params)

    if valid?
      update_app!
    end
  end

  def placeholder(field)
    placeholders[field].present? ? "(#{placeholders[field]})" : ""
  end

  def type(field)
    types.fetch(field, :text)
  end

  def assign_from_app
    raise "Implement Me"
  end

  def update_app!
    raise "Implement Me"
  end
end
