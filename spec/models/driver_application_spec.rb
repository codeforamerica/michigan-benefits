require "rails_helper"

RSpec.describe DriverApplication do
  describe "Associations" do
    it { should belong_to(:snap_application) }
  end

  describe "Validations" do
    it { should validate_presence_of(:snap_application) }
  end
end
