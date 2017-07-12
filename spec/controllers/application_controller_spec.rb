# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  let(:user) { create :user }
  let(:admin) { create :admin }

  describe 'allowed user levels' do
    def expect_allowed(level, expected_to_be_allowed)
      case level
      when :admin then
        login_user(admin)
      when :member then
        login_user(user)
      else
        logout_user
      end

      get :index

      if expected_to_be_allowed
        expect(response.code).to eq '200'
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

      it 'only lets admins in' do
        expect_allowed :admin, true
        expect_allowed :member, false
        expect_allowed :guest, false
      end
    end

    context 'actions that specify admin' do
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

      it 'only lets admins in' do
        expect_allowed :admin, true
        expect_allowed :member, false
        expect_allowed :guest, false
      end
    end

    context 'actions that specify member' do
      controller do
        def allowed
          {
            index: :member
          }
        end

        def index
          head :ok
        end
      end

      it 'lets admins and members in' do
        expect_allowed :admin, true
        expect_allowed :member, true
        expect_allowed :guest, false
      end
    end

    context 'actions that specify guest' do
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

      it 'lets admins and members in' do
        expect_allowed :admin, true
        expect_allowed :member, true
        expect_allowed :guest, true
      end
    end
  end

  describe 'basic auth' do
    around(:each) do |example|
      with_modified_env BASIC_AUTH: basic_auth do
        example.run
      end
    end

    controller do
      def allowed
        { index: :guest }
      end

      def index
        head :ok
      end
    end

    context 'when no user or password specified' do
      let(:basic_auth) { '' }

      specify do
        get :index
        expect(response.code).to eq '200'
      end
    end

    context 'when user and password specified' do
      let(:basic_auth) { 'user:pass' }

      specify 'valid credentials' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('user', 'pass')

        get :index
        expect(response.code).to eq '200'
      end

      specify 'invalid credentials' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('user', 'WRONG')

        get :index
        expect(response.code).to eq '401'
      end
    end
  end
end
