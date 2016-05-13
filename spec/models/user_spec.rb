require 'rails_helper'

describe User do
  describe "Validations" do
    it "requires unique email addresses (ignoring case)" do
      alice = create :user, email: "alice@example.com"

      expect(alice).to be_valid
      expect(build :user, email: "billy@example.com").to be_valid
      expect(build :user, email: "alice@example.com").not_to be_valid
      expect(build :user, email: "ALICE@example.COM").not_to be_valid
    end

    it "requires a password of at least 8 characters when changing the password" do
      expect(build :user, password: nil).not_to be_valid
      expect(build :user, password: "").not_to be_valid
      expect(build :user, password: "short").not_to be_valid
      expect(build :user, password: "longlonglong").to be_valid
    end

    it "does not validate the password when not changing the password" do
      alice = build :user, password: "short"
      expect(alice).not_to be_valid

      alice.password = "longlonglong"
      expect(alice).to be_valid

      alice.save!

      alice.name = "Alice"
      expect(alice).to be_valid
    end

    it "requires a name" do
      expect(build :user, nil).not_to be_valid
      expect(build :user, "").not_to be_valid
      expect(build :user, "Alice").to be_valid
    end
  end

  describe "email" do
    it "is downcased before user is saved" do
      expect(create(:user, email: "YELLING@EXAMPLE.COM").email).to eq "yelling@example.com"
    end
  end
end

