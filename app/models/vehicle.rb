class Vehicle < ApplicationRecord
  VEHICLE_TYPES = {
    car: "Car",
    truck: "Truck",
    motorcycle: "Motorcycle",
    boat: "Boat",
    other: "Other vehicle",
  }.freeze

  has_and_belongs_to_many :members,
    class_name: "HouseholdMember",
    foreign_key: "vehicle_id"

  def self.all_vehicle_types
    VEHICLE_TYPES.keys
  end

  validates :vehicle_type, inclusion: { in: all_vehicle_types.map(&:to_s),
                                        message: "%<value>s is not a valid vehicle type" }

  def display_name
    VEHICLE_TYPES[vehicle_type.to_sym]
  end

  def display_name_and_make
    make = year_make_model.present? ? ": #{year_make_model}" : ""
    "#{display_name}#{make}"
  end

  def member_names
    members.map(&:display_name).join(", ")
  end
end
