require "administrate/field/base"

class PresenceField < Administrate::Field::Base
  def to_s
    data.present?
  end
end
