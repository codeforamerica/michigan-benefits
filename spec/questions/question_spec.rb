require "rails_helper"

describe Question do
  describe "#name" do
    specify { expect(FirstName.new(App.new).name).to eq :first_name }
  end
end
