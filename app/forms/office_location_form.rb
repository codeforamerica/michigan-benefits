class OfficeLocationForm < Form
  set_attributes_for :application, :selected_office_location

  validates_presence_of :selected_office_location,
    message: "Make sure to select a location."
end
