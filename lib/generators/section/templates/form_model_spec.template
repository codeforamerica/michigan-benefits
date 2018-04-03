require "rails_helper"

RSpec.describe <%= model.camelcase %>Form do
  describe "validations" do
    <%- if options.doc? -%>
    # Add any required validations here
    <%- end -%>
    xit "requires some attribute" do
      form = <%= "#{model.camelcase}Form".classify %>.new

      expect(form).not_to be_valid
      expect(form.errors[:some_attribute]).to be_present
    end
  end
end
