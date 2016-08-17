module GenericHelper
  def with_modified_env(options, &block)
    raise "values must all be strings" unless options.all? { |k, v| v.is_a? String }
    ClimateControl.modify(options, &block)
  end
end
