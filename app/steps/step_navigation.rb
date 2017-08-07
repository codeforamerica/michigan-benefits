# frozen_string_literal: true

class StepNavigation
  ALL = {
    "Minimal Snap Application" => [
      PersonalDetailController,
      ContactInformationController,
      AddressController,
      DocumentsController,
      SignAndSubmitController,
      SendApplicationController,
    ],
  }.freeze

  SUBSTEPS = {}.freeze

  class << self
    delegate :first, to: :steps

    def sections
      ALL
    end

    def steps
      @steps ||= ALL.values.flatten.freeze
    end

    def steps_and_substeps
      @steps_and_substeps ||= (steps + SUBSTEPS.keys).uniq.freeze
    end
  end

  delegate :steps, to: :class

  def initialize(step_instance_or_class)
    @step =
      if step_instance_or_class.is_a?(Class)
        step_instance_or_class
      else
        step_instance_or_class.class
      end
  end

  def next
    step_at(1)
  end

  def previous
    step_at(-1)
  end

  def index
    steps.index(@step)
  end

  def parent
    self.class.new(SUBSTEPS[@step])
  end

  private

  def step_at(increment)
    if index
      new_index = index + increment
      new_index = nil if new_index.negative? || new_index >= steps.length
    else
      new_index = parent.index
    end

    steps.at(new_index) if new_index
  end
end
