module MiBridges
  class Driver
    class SchoolEnrollmentPage < FillInAndClickNextPage
      def self.title
        "School Enrollment"
      end

      def setup
        @current_member = find_current_member
      end

      def fill_in_required_fields
        choose_enrollment_time_for
        choose_highest_grade_completion_for
      end

      private

      attr_reader :current_member

      def choose_enrollment_time_for
        selector = if current_member.in_college
                     selector_for_radio("Full time")
                   else
                     selector_for_radio("Not in school")
                   end

        js_click_selector(selector)
      end

      def choose_highest_grade_completion_for
        select("Unknown", from: "highestGradeInSchool")
      end

      def find_current_member
        within(first("#helpContent")) do
          snap_application.members.detect do |member|
            member_first_name = Regexp.new(
              Regexp.escape(member.mi_bridges_formatted_name),
            )
            page.has_content?(member_first_name)
          end
        end
      end
    end
  end
end
