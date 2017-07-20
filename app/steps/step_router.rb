# frozen_string_literal: true

# This allows e.g. /steps/introduction-introduce-yourself to correctly route to
# IntroductionIntroduceYourselfController. Without this, routing to StepsController takes
# precedence over routing to its children.
class StepRouter
  ACTIONS_BY_REQUEST_METHOD = {
    'GET' => :edit,
    'PUT' => :update
  }.freeze

  STEP_AND_SUBSTEPS_BY_PARAM =
    StepNavigation.steps_and_substeps.index_by(&:to_param).freeze

  def self.call(env)
    new(env).call
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def call
    if action
      controller_class.action(action).call(@request.env)
    else
      # Returning the X-Cascade header causes ActionDispatch's routing to continue looking
      # for more routes after this one.
      [404, { 'X-Cascade' => 'pass' }, []]
    end
  end

  private

  def action
    @action ||= ACTIONS_BY_REQUEST_METHOD[@request.request_method] if controller_class
  end

  def controller_class
    @controller_class ||= STEP_AND_SUBSTEPS_BY_PARAM[
      @request.env['action_dispatch.request.path_parameters'][:__step_name__]
    ]
  end
end
