class Step
  include ActiveModel::Model

  class_attribute :title, :headline, :subhead
  class_attribute :questions, instance_accessor: false

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

  def questions
    @questions ||= self.class.questions.map do |question_class|
      question_class.new(@app)
    end
  end

  def to_param
    self.class.to_param
  end

  def update(params)
    questions.each do |question|
      question.value = params[question.name]
    end

    if valid?
      questions.each do |question|
        question.set
      end
      @app.save!
    end
  end

  def valid?
    questions.all?(&:valid?)
  end

  def errors
    questions.map(&:errors).flatten
  end
end
