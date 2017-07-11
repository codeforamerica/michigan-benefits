class SimpleStep
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  # TODO: We should be using a path helper here because this info exists here and
  # in routes.rb
  def self.path
    "/steps/#{to_param}"
  end

  delegate :path, to: :class

  def self.to_param
    name.underscore.dasherize
  end
end
