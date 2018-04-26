class Employment < ApplicationRecord
  belongs_to :application_member, polymorphic: true
end
