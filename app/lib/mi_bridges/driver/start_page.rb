module MiBridges
  class Driver
    class StartPage < FillInAndClickNextPage
      CIVILLA_COMMUNITY_PARTNER_ID = 3949

      def self.title
        "Help With Filing MI Bridges Application"
      end

      def fill_in_required_fields
        fill_in "agencyNumber", with: CIVILLA_COMMUNITY_PARTNER_ID
        click_id(a_staff_person_or_volunteer_at_an_agency)
      end

      private

      def a_staff_person_or_volunteer_at_an_agency
        "#radioGroup_2"
      end
    end
  end
end
