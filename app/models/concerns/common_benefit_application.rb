module CommonBenefitApplication
  extend ActiveSupport::Concern

  def last_emailed_office_at
    exports.emailed_office.succeeded.first&.completed_at
  end

  def signed_at_est(fmt = "%m/%d/%Y at %I:%M%p %Z")
    signed_at&.
      in_time_zone("Eastern Time (US & Canada)")&.
      strftime(fmt)
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end

  def display_name
    primary_member.display_name
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def stable_housing?
    stable_housing == true || stable_housing == nil
  end

  def unstable_housing?
    stable_housing == false
  end
end
