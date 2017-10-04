require "administrate/field/base"

class HtmlCodeField < Administrate::Field::Base
  def to_s
    data
  end
end
