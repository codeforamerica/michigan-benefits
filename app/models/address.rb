class Address < ApplicationRecord
  belongs_to :benefit_application, polymorphic: true
end
