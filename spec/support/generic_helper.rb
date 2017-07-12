# frozen_string_literal: true

module GenericHelper
  def with_modified_env(options, &block)
    raise 'values must all be strings' unless options.all? { |_k, v| v.is_a? String }
    ClimateControl.modify(options, &block)
  end
end
