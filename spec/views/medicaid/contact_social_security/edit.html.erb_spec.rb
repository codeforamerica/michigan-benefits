require "rails_helper"

describe "medicaid/contact_social_security/edit.html.erb" do
  before do
    controller.singleton_class.class_eval do
      def current_path
        "/steps/medicaid/contact_social_security"
      end

      helper_method :current_path
    end
  end

  context "one member has an invalid SSN" do
    it "shows an error for that one member" do
      controller.singleton_class.class_eval do
        def single_member_household?
          true
        end

        helper_method :single_member_household?
      end

      app = create(:medicaid_application, anyone_new_mom: true)
      member = build(:member, ssn: "wrong", benefit_application: app)
      member.save(validate: false)
      member.valid?
      step = Medicaid::ContactSocialSecurity.new(members: [member])
      assign(:step, step)

      render

      expect(rendered).to include("Make sure to provide 9 digits")
    end
  end

  context "two members have invalid SSN's" do
    it "shows errors for each member" do
      controller.singleton_class.class_eval do
        def single_member_household?
          false
        end

        helper_method :single_member_household?
      end

      app = create(:medicaid_application, anyone_new_mom: true)

      member1 = build(:member, ssn: "wrong", benefit_application: app)
      member1.save(validate: false)
      member1.valid?

      member2 = build(:member, ssn: "nope", benefit_application: app)
      member2.save(validate: false)
      member2.valid?

      step = Medicaid::ContactSocialSecurity.new(members: [member1, member2])
      assign(:step, step)

      render
      expect(rendered.scan("Make sure to provide 9 digits").size).to eq 2
    end
  end
end
