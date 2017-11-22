require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusIndicateSpouseController do
  describe "#current_member" do
    it "defaults for first married member" do
      medicaid_application = create(:medicaid_application, anyone_married: true)
      _primary_member = create(
        :member,
        married: false,
        benefit_application: medicaid_application,
      )
      married_member = create(
        :member,
        married: true,
        benefit_application: medicaid_application,
      )

      session[:medicaid_application_id] = medicaid_application.id

      get :edit, params: {}

      expect(subject.current_member).to eq married_member
    end

    it "finds member from querystring" do
      medicaid_application = create(:medicaid_application, anyone_married: true)
      _joel = create(:member, benefit_application: medicaid_application)
      jessie = create(:member, benefit_application: medicaid_application)

      session[:medicaid_application_id] = medicaid_application.id

      get :edit, params: { member: jessie.id }

      expect(subject.current_member).to eq jessie
    end
  end

  describe "#next_path" do
    it "is the intro college path" do
      medicaid_application = create(:medicaid_application)
      session[:medicaid_application_id] = medicaid_application.id

      expect(subject.next_path).to eq "/steps/medicaid/intro-college"
    end
  end

  describe "#edit" do
    context "single member household" do
      it "skips this page" do
        medicaid_application = create(
          :medicaid_application,
          members: [build(:member)],
          anyone_married: true,
        )

        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "multi member household" do
      context "someone is married" do
        it "renders :edit" do
          medicaid_application = create(
            :medicaid_application,
            anyone_married: true,
            members: build_list(:member, 2, married: true),
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end

      context "nobody is married" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            anyone_married: false,
          )
          build_list(:member, 2, benefit_application: medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "current member has spouse id" do
        it "skips this page" do
          member_one = build(
            :member,
            married: true,
            spouse_id: 0,
          )

          medicaid_application = create(
            :medicaid_application,
            anyone_married: true,
            members: [member_one, build(:member)],
          )

          session[:medicaid_application_id] = medicaid_application.id

          get :edit, params: { member: member_one }

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end

  describe "#update" do
    context "member's spouse is updated" do
      it "update the spouse_id of their spouse as well" do
        medicaid_application = create(
          :medicaid_application,
          anyone_married: true,
        )
        first_member = create(
          :member,
          benefit_application: medicaid_application,
          spouse_id: nil,
        )
        second_member = create(
          :member,
          benefit_application: medicaid_application,
          spouse_id: nil,
        )
        session[:medicaid_application_id] = medicaid_application.id

        put(
          :update,
          params: {
            step: { member_id: first_member.id, spouse_id: second_member.id },
          },
        )
        first_member.reload
        second_member.reload

        expect(second_member.spouse).to eq first_member
        expect(first_member.spouse).to eq second_member
      end
    end

    context "member's spouse is updated to 'other'" do
      it "does not error" do
        medicaid_application = create(
          :medicaid_application,
          anyone_married: true,
        )
        first_member = create(
          :member,
          benefit_application: medicaid_application,
          spouse_id: nil,
        )
        session[:medicaid_application_id] = medicaid_application.id

        put(
          :update,
          params: {
            step: { member_id: first_member.id, spouse_id: OtherSpouse.new.id },
          },
        )
        first_member.reload

        expect(first_member.spouse_id).to eq OtherSpouse.new.id
      end
    end
  end
end
