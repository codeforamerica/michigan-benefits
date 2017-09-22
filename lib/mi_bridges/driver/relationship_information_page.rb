# frozen_string_literal: true

module MiBridges
  class Driver
    class RelationshipInformationPage < BasePage
      TITLE = "Relationship Information"

      def setup
        @first_member = find_first_member
        @second_members = find_second_members
      end

      def fill_in_required_fields
        second_members.each do |member|
          MiBridges::Driver::Services::SubmitRelationship.new(
            first_member: first_member,
            second_member: member,
          ).run
          MiBridges::Driver::Services::SubmitBuyFoodWith.new(
            first_member: first_member,
            second_member: member,
          ).run
        end
      end

      def continue
        click_on "Next"
      end

      private

      attr_reader :first_member, :second_members

      def find_first_member
        name = page.first(:xpath, first_member_name_label).text
        find_household_member_by_name(name)
      end

      def first_member_name_label
        '//*[@id="helpContent"]/div/div[2]/div/div[1]/div[1]/div/div/div/label'
      end

      def find_second_members
        labels = page.all(:xpath, second_member_name_label)
        labels.map do |label|
          find_household_member_by_name(label.text)
        end
      end

      def second_member_name_label
        '//*[@id="helpContent"]/div/div[2]/div/div[1]/div[4]/div/div/div/label'
      end

      def find_household_member_by_name(name)
        snap_application.members.detect do |member|
          member.mi_bridges_formatted_name == name
        end
      end
    end
  end
end
