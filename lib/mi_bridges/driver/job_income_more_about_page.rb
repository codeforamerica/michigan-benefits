# frozen_string_literal: true

module MiBridges
  class Driver
    class JobIncomeMoreAboutPage < BasePage
      TITLE = /More About (.*)'s Job/

      delegate :members, to: :snap_application

      def setup; end

      def fill_in_required_fields
        fill_in(
          "Name of Employer",
          with: current_member.employed_employer_name,
        )

        select(
          current_member.employed_pay_interval,
          from: "How often does #{name} get paid? This is #{name}'s pay period",
        )

        if hourly?
          fill_in_hourly
        else
          fill_in_salary
        end
      end

      def continue
        click_on "Next"
      end

      private

      def hourly?
        current_member.employed_pay_interval != "Yearly"
      end

      def fill_in_hourly
        fill_in(
          "If #{name} gets paid by the hour, ",
          with: current_member.employed_pay_quantity,
        )

        fill_in(
          "Please tell us how many hours #{name} works",
          with: current_member.employed_hours_per_week,
        )
      end

      def fill_in_salary
        fill_in(
          "If #{name} earns a salary instead",
          with: current_member.employed_pay_quantity,
        )
      end

      def current_member
        members.select do |member|
          member.mi_bridges_formatted_name == name
        end.first
      end

      def name
        @_name ||= begin
                     title = find("h1").text
                     title.scan(TITLE).flatten.first
                   end
      end
    end
  end
end
