# frozen_string_literal: true

class Step
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute \
    :icon,
    :title,
    :headline,
    :subhead,
    :subhead_help,
    :questions,
    :member_questions,
    :member_grouped_questions,
    :household_questions,
    :placeholders,
    :field_options,
    :types,
    :section_headers,
    :overviews,
    :safeties,
    :help_messages

  attr_reader :params

  def self.first
    IntroductionIntroduceYourselfController
  end

  def self.find(id, app, params = {})
    klass = id.tr('-', '_').camelize.constantize
    raise TypeError, "Update StepNavigation for #{klass}!" if klass < SimpleStep
    klass.new(app, params)
  end

  def self.to_param
    name.underscore.dasherize
  end

  def self.template
    name.underscore
  end

  def initialize(app, params = {})
    self.questions ||= {}
    self.member_questions ||= {}
    self.household_questions ||= {}
    self.member_grouped_questions ||= {}
    self.placeholders ||= {}
    self.types ||= {}
    self.section_headers ||= {}
    self.overviews ||= {}
    self.safeties ||= {}
    self.help_messages ||= {}

    @app = app
    @params = params
    assign_from_app
  end

  def template
    self.class.template
  end

  def skip?
    false # override me to skip
  end

  delegate :next, to: :nav

  delegate :previous, to: :nav

  def nav
    StepNavigation.new(self)
  end

  def overview(question)
    overviews[question]
  end

  def safety(question)
    safeties[question]
  end

  def help_message(question)
    help_messages[question]
  end

  def only_subhead?
    subhead && !headline && !icon
  end

  def to_param
    self.class.to_param
  end

  def check(checkboxes)
    checkboxes.select { |c| send(c) == '1' }.map(&:to_s)
  end

  def update(params)
    assign_attributes(params)

    update_app! if valid?
  end

  def options_for(field)
    field_options&.fetch(field, '')
  end

  def placeholder(field)
    placeholders.fetch(field, '')
  end

  def type(field)
    types.fetch(field, :text)
  end

  def submit_label
    'Continue'
  end

  def section_header(field)
    section_headers.fetch(field, nil)
  end

  def assign_from_app
    raise 'Implement Me'
  end

  def update_app!
    raise 'Implement Me'
  end

  def allowed_params
    questions.keys
  end
end
