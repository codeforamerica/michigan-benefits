class Question
  class_attribute :title, :placeholder, :type

  self.type = :text

  def self.find(id, app)
    id.to_s.gsub("-", "_").camelize.constantize.new(app)
  end

  def self.to_param
    self.name.underscore.dasherize
  end

  def initialize(app)
    @app = app
  end

  def name
    self.class.name.underscore.to_sym
  end
end
