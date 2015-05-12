require 'rails_helper'

describe AccountsMailer do
  describe ".reset_password_email" do
    before do
      @claimed = create(:account)
      @claimed.deliver_reset_password_instructions!
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq [@claimed.email]
      @body = mail.body.encoded
    end

    it "sends a 'reset' email to claimed accounts" do
      expect(@body).to match /reset/
    end

    it "renders the email footer" do
      expect(@body).to match /Disclosure/i
    end
  end
end
