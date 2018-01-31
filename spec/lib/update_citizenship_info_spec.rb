require "rails_helper"

describe UpdateCitizenshipInfo do
  describe "#run" do
    context "everyone_a_citizen is true" do
      let!(:snap_applications) do
        create_list(:snap_application, 2,
                    :multimember,
                    everyone_a_citizen: true)
      end

      let!(:medicaid_applications) do
        create_list(:medicaid_application, 2,
                    :multimember,
                    everyone_a_citizen: true)
      end

      context "citizen is unset" do
        it "updates all members' citizenship to true" do
          UpdateCitizenshipInfo.new.run

          snap_members = medicaid_applications.flat_map(&:members)
          snap_members.each(&:reload)

          medicaid_members = medicaid_applications.flat_map(&:members)
          medicaid_members.each(&:reload)

          snap_members.each do |member|
            expect(member.citizen).to eq(true)
          end

          medicaid_members.each do |member|
            expect(member.citizen).to eq(true)
          end
        end
      end

      context "citizen is set" do
        it "does not update citizenship status" do
          snap_applications.flat_map(&:members).each { |m| m.update(citizen: false) }
          medicaid_applications.flat_map(&:members).each { |m| m.update(citizen: false) }

          UpdateCitizenshipInfo.new.run

          snap_members = medicaid_applications.flat_map(&:members)
          snap_members.each(&:reload)

          medicaid_members = medicaid_applications.flat_map(&:members)
          medicaid_members.each(&:reload)

          snap_members.each do |member|
            expect(member.citizen).to eq(false)
          end

          medicaid_members.each do |member|
            expect(member.citizen).to eq(false)
          end
        end
      end
    end

    context "everyone_a_citizen is false" do
      let!(:snap_applications) do
        create_list(:snap_application, 2,
                    :multimember,
                    everyone_a_citizen: false)
      end

      let!(:medicaid_applications) do
        create_list(:medicaid_application, 2,
                    :multimember,
                    everyone_a_citizen: false)
      end

      it "does not update citizenship status" do
        snap_applications.flat_map(&:members).each { |m| m.update(citizen: nil) }
        medicaid_applications.flat_map(&:members).each { |m| m.update(citizen: nil) }

        snap_members = medicaid_applications.flat_map(&:members)
        snap_members.each(&:reload)

        medicaid_members = medicaid_applications.flat_map(&:members)
        medicaid_members.each(&:reload)

        snap_members.each do |member|
          expect(member.citizen).to eq(nil)
        end

        medicaid_members.each do |member|
          expect(member.citizen).to eq(nil)
        end
      end
    end
  end
end
