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
          fill_in_relationship(member)
          buy_food_with(member)
        end
      end

      def continue
        click_on "Next"
      end

      private

      attr_reader :first_member, :second_members

      def fill_in_relationship(member)
        selector = find(:xpath, relationship_xpath(member))
        selector.select(mi_bridges_relationship(member))
      end

      def relationship_xpath(member)
        second = member.mi_bridges_formatted_name
        "//*[@title=\"* #{first_member_name}\'s Relationship to #{second}\"]"
      end

      def buy_food_with(member)
        buy_food_with_section =
          find("fieldset", text: buy_food_with_label(member))

        within buy_food_with_section do
          find(:xpath, ".//*[@title='#{buy_food_with_option(member)}']").click
        end
      end

      def buy_food_with_label(member)
        second = member.mi_bridges_formatted_name
        "Does #{first_member_name} usually buy and fix food with #{second}?"
      end

      def buy_food_with_option(member)
        if member.buy_food_with?
          "Yes"
        else
          "No"
        end
      end

      def first_member_name
        first_member.mi_bridges_formatted_name
      end

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

      def mi_bridges_relationship(member)
        if first_member == snap_application.primary_member
          map_member_relationship_to_mi_bridges(member)
        else
          "is Related to another way to"
        end
      end

      def map_member_relationship_to_mi_bridges(member)
        relationship = member.relationship || "Other"
        sex = first_member.sex
        mapping = send("#{sex}_relationship_mapping".to_sym).
          merge(other_relationship_mapping)
        mapping[relationship]
      end

      def female_relationship_mapping
        {
          "Child" => "is the Mother of",
          "Parent" => "is the Daughter of",
          "Sibling" => "is the Sister of",
          "Spouse" => "is the Wife of",
        }
      end

      def male_relationship_mapping
        {
          "Child" => "is the Father of",
          "Parent" => "is the Son of",
          "Sibling" => "is the Brother of",
          "Spouse" => "is the Husband of",
        }
      end

      def other_relationship_mapping
        {
          "Roommate" => "is Related to another way to",
          "Other" => "is Related to another way to",
        }
      end
    end
  end
end
