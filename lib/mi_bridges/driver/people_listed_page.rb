# frozen_string_literal: true

module MiBridges
  class Driver
    class PeopleListedPage < BasePage
      TITLE = "People Listed On Your Application"

      delegate :primary_member, to: :snap_application

      def setup; end

      def fill_in_required_fields
        select primary_member.marital_status.titleize, from: "maritalStatus"
        fill_in "peopleInYourHome", with: snap_application.members.size
      end

      def continue
        click_on "Next"
      end
    end
  end
end
