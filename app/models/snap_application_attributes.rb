class SnapApplicationAttributes
  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def to_h
    {
      applying_for_food_assistance: "Yes",
      birth_day: primary_member.birthday.strftime("%d"),
      birth_month: primary_member.birthday.strftime("%m"),
      birth_year: primary_member.birthday.strftime("%Y"),
      phone_number: snap_application.phone_number,
      mailing_address_street_address:
        snap_application.mailing_address.street_address,
      mailing_address_city: snap_application.mailing_address.city,
      mailing_address_county: snap_application.mailing_address.county,
      mailing_address_state: snap_application.mailing_address.state,
      mailing_address_zip: snap_application.mailing_address.zip,
      residential_address_street_address: residential_or_homeless,
      residential_address_city: snap_application.residential_address.city,
      residential_address_county: snap_application.residential_address.county,
      residential_address_state: snap_application.residential_address.state,
      residential_address_zip: snap_application.mailing_address.zip,
      email: snap_application.email,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
      members_buy_food_with_yes:
        boolean_to_checkbox(all_members_buy_food_with?),
      members_buy_food_with_no:
        boolean_to_checkbox(any_members_not_buy_food_with?),
      members_not_buy_food_with: members_not_buy_food_with,
    }
  end

  private

  attr_reader :snap_application

  def primary_member
    @_primary_member ||= snap_application.primary_member
  end

  def boolean_to_checkbox(statement)
    if statement == true
      "Yes"
    end
  end

  def residential_or_homeless
    if snap_application.unstable_housing?
      "Homeless"
    else
      snap_application.residential_address.street_address
    end
  end

  def all_members_buy_food_with?
    !buy_food_with.include?(false)
  end

  def any_members_not_buy_food_with?
    buy_food_with.include?(false)
  end

  def buy_food_with
    snap_application.members.map(&:buy_food_with?)
  end

  def members_not_buy_food_with
    snap_application.
      members.
      where.
      not(buy_food_with: true).
      map(&:full_name).
      to_sentence
  end
end
