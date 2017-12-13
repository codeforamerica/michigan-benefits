module MiBridges
  class Driver
    module Services
      class SubmitRelationship
        include Capybara::DSL

        def initialize(first_member:, second_member:)
          @first_member = first_member
          @second_member = second_member
        end

        def run
          selector = find(:xpath, relationship_xpath)
          selector.select(mi_bridges_relationship)
        end

        private

        attr_reader :first_member, :second_member

        def relationship_xpath
          "//*[@title=\"* #{first_name}\'s Relationship to #{second_name}\"]"
        end

        def first_name
          first_member.mi_bridges_formatted_name
        end

        def second_name
          second_member.mi_bridges_formatted_name
        end

        def mi_bridges_relationship
          if first_member == first_member.benefit_application.primary_member
            map_member_relationship_to_mi_bridges
          else
            "is Related to another way to"
          end
        end

        def map_member_relationship_to_mi_bridges
          mapping[simple_relationship]
        end

        def mapping
          send("#{first_member.sex}_relationship_mapping".to_sym).
            merge(other_relationship_mapping)
        end

        def simple_relationship
          second_member.relationship || "Other"
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
end
