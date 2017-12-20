module MiBridges
  class Driver
    class ImportantInformationPage < BasePage
      def self.title
        "Important Information and Signature"
      end

      delegate :primary_member, to: :snap_application

      def setup; end

      def fill_in_required_fields
        check_in_electronic_signature
        fill_in_electronic_signature
      end

      def continue; end

      private

      def check_in_electronic_signature
        check_in_section(
          "ElectronicSignature",
          condition: true,
          for_label: "By checking this box and typing my name below, " +
                     "I am electronically signing my application.",
        )
      end

      def fill_in_electronic_signature
        fill_in "firstName", with: primary_member.first_name
        fill_in "lastName", with: primary_member.last_name
      end
    end
  end
end
