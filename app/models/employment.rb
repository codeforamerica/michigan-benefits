class Employment < ApplicationRecord
  belongs_to :application_member, polymorphic: true, counter_cache: true
end
