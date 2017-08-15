# frozen_string_literal: true

module StepHelper
  def data_md5(*args)
    StepsHelper.
      instance_method(:data_md5).
      bind(self).
      call(*args)
  end
end
