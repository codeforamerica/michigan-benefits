# frozen_string_literal: true

require 'rails_helper'

describe SessionsController do
  describe 'routing' do
    specify do
      expect(get: '/sessions/new').to route_to 'sessions#new'
      expect(delete: '/sessions').to route_to 'sessions#destroy'
    end
  end

  describe '#new' do
    specify do
      get :new
      expect(response.code).to redirect_to root_path
    end
  end

  describe '#destroy', :member do
    specify do
      expect do
        delete :destroy
      end.to change { logged_in? }.from(true).to(false)
      expect(response).to redirect_to root_path
    end
  end
end
