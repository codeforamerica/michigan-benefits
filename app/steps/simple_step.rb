class SimpleStep
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  # TODO: We should be using a path helper here because this info exists here and
  # in routes.rb
  def self.path
    "/steps/#{name.underscore.dasherize}"
  end

  delegate :path, to: :class
end
