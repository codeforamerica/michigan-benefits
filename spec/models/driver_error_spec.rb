require "rails_helper"

RSpec.describe DriverError, type: :model do
  describe "associations" do
    it { should belong_to(:driver_application) }
  end

  describe "validations" do
    it { should validate_presence_of(:driver_application) }
    it { should validate_presence_of(:error_class) }
    it { should validate_presence_of(:error_message) }
    it { should validate_presence_of(:page_class) }
    it { should validate_presence_of(:page_html) }
  end
end
