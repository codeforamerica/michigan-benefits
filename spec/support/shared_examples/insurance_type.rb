require "rails_helper"

RSpec.shared_examples_for "insurance type" do |insurance_slug, insurance_name|
  context "one household member with #{insurance_name}" do
    it "sets insured_#{insurance_slug}_yes to 'Yes' and lists their name" do
      member_with_insurance = build(
        :member,
        first_name: "Christa",
        last_name: "Person",
        insurance_type: insurance_name,
      )
      member_without_insurance = build(
        :member,
        first_name: "Ben",
        last_name: "Person",
      )
      medicaid_application = create(
        :medicaid_application,
        members: [member_with_insurance, member_without_insurance],
      )

      expected_data = {
        "insured_#{insurance_slug}_yes".to_sym => "Yes",
        "insured_#{insurance_slug}_member_names".to_sym => "Christa",
      }

      data = MedicaidApplicationAttributes.new(
        medicaid_application: medicaid_application,
      ).to_h

      expect(data).to include(expected_data)
    end
  end
  context "multiple household members with #{insurance_name}" do
    it "sets insured_#{insurance_slug}_yes to 'Yes' and lists their names" do
      member_one = build(
        :member,
        first_name: "Christa",
        last_name: "Person",
        insurance_type: insurance_name,
      )
      member_two = build(
        :member,
        first_name: "Ben",
        last_name: "Person",
        insurance_type: insurance_name,
      )
      medicaid_application = create(
        :medicaid_application,
        members: [member_one, member_two],
      )

      expected_data = {
        "insured_#{insurance_slug}_yes".to_sym => "Yes",
        "insured_#{insurance_slug}_member_names".to_sym => "Christa, Ben",
      }
      data = MedicaidApplicationAttributes.new(
        medicaid_application: medicaid_application,
      ).to_h

      expect(data).to include(expected_data)
    end
  end
end
