# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IntroductionIntroduceYourselfController, :member, type: :controller do
  let!(:current_app) do
    App.create!(user: @member)
  end

  describe '#edit' do
    before do
      current_app.applicant.update(first_name: 'bob', last_name: 'smith')
    end

    it 'assigns the correct step' do
      get :edit
      expect(assigns(:step)).to be_an_instance_of IntroductionIntroduceYourself
    end

    it 'assigns the first name to the step' do
      get :edit
      expect(assigns(:step).first_name).to eq('bob')
    end

    it 'assigns the last name to the step' do
      get :edit
      expect(assigns(:step).last_name).to eq('smith')
    end
  end

  describe '#update' do
    it 'updates the applicant if the step is valid' do
      expect do
        put :update, params: {
          step: {
            first_name: 'bob',
            last_name: 'smith'
          }
        }
      end.to change {
        current_app.applicant.reload.attributes.slice('first_name', 'last_name')
      }
    end

    it 'redirects to the next step if the step is valid' do
      put :update, params: {
        step: {
          first_name: 'bob',
          last_name: 'smith'
        }
      }

      expect(response).to redirect_to('/steps/introduction-contact-information')
    end

    it 'renders edit if the step is invalid' do
      put :update, params: {
        step: {
          first_name: nil,
          last_name: nil
        }
      }

      expect(assigns(:step)).to be_an_instance_of(IntroductionIntroduceYourself)
      expect(response).to render_template(:edit)
    end
  end
end
