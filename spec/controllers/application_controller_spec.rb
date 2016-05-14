require "rails_helper"

describe ApplicationController do
  let(:user) { create :user }
  let(:admin) { create :admin }

  describe "allowed user levels" do
    def expect_allowed(level, expected_to_be_allowed)
      case level
        when :admin then
          login_user(admin)
        when :user then
          login_user(user)
        else
          logout_user
      end

      get :index

      if expected_to_be_allowed
        expect(response.code).to eq "200"
      else
        expect(response).to redirect_to new_sessions_path
      end
    end

    context "actions that don't specify an allowed user level" do
      controller do
        def index
          head :ok
        end
      end

      it "only lets admins in" do
        expect_allowed :admin, true
        expect_allowed :user, false
        expect_allowed :guest, false
      end
    end

    context "actions that specify admin" do
      controller do
        def allowed
          {
            index: :admin
          }
        end

        def index
          head :ok
        end
      end

      it "only lets admins in" do
        expect_allowed :admin, true
        expect_allowed :user, false
        expect_allowed :guest, false
      end
    end

    context "actions that specify user" do
      controller do
        def allowed
          {
            index: :user
          }
        end

        def index
          head :ok
        end
      end

      it "lets admins and users in" do
        expect_allowed :admin, true
        expect_allowed :user, true
        expect_allowed :guest, false
      end
    end

    context "actions that specify guest" do
      controller do
        def allowed
          {
            index: :guest
          }
        end

        def index
          head :ok
        end
      end

      it "lets admins and users in" do
        expect_allowed :admin, true
        expect_allowed :user, true
        expect_allowed :guest, true
      end
    end
  end
end
