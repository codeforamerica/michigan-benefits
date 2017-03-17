class Step
  include ActiveModel::Model

  class_attribute :title, :headline, :subhead

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
  end

  def to_param
    self.class.to_param
  end

  def update(params)
    questions.each do |question|
      Question.find(question.name, @app).update(params[question.name])
    end
    @app.save!
  end
end
