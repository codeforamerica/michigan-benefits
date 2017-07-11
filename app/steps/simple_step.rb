class SimpleStep
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  def self.to_param
    name.underscore.dasherize
  end
end
