require "rails_helper"

describe FirstName do
  let(:app) { App.new }
  let(:first_name) { FirstName.new(app) }

  specify "validations" do
    expect(first_name).not_to be_valid

    app.first_name = ""
    first_name = FirstName.new(App.new)
    expect(first_name).not_to be_valid

    first_name.value = ""
    expect(first_name).not_to be_valid

    first_name.value = "Fred"
    expect(first_name).to be_valid
  end
end
