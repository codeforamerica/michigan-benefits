# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IntroductionContactInformationController, :member, type: :controller do
  let!(:current_app) do
    App.create!(
      user: @member,
      phone_number: '1234567890',
      accepts_text_messages: true,
      mailing_street: '123 Fake St',
      mailing_city: 'Springfield',
      mailing_zip: '12345',
      mailing_address_same_as_home_address: true,
      email: 'email@example.com',
      welcome_sms_sent: true
    )
  end

  let(:step) { assigns(:step) }

  describe '#edit' do
    it 'assigns the correct step' do
      get :edit
      expect(step).to be_an_instance_of IntroductionContactInformation
    end

    it 'assigns the fields to the step' do
      get :edit
      expect(step.phone_number).to eq('1234567890')
      expect(step.accepts_text_messages).to be
      expect(step.mailing_street).to eq('123 Fake St')
      expect(step.mailing_city).to eq('Springfield')
      expect(step.mailing_zip).to eq('12345')
      expect(step.mailing_address_same_as_home_address).to be
      expect(step.email).to eq('email@example.com')
    end
  end

  describe '#update' do
    context 'when valid' do
      let(:valid_params) do
        {
          phone_number: '0987654321',
          accepts_text_messages: false,
          mailing_street: '321 Real St',
          mailing_city: 'Shelbyville',
          mailing_zip: '54321',
          mailing_address_same_as_home_address: false,
          email: 'snailmail@example.com'
        }
      end

      let(:sms) do
        instance_double('Sms')
      end

      before do
        allow(class_double('Sms').as_stubbed_const)
          .to receive(:new)
          .with(an_instance_of(App))
          .and_return(sms)
      end

      it 'updates the app' do
        put :update, params: { step: valid_params }

        current_app.reload

        valid_params.each do |key, value|
          expect(current_app[key]).to eq(value)
        end
      end

      it 'sends an SMS and updates the flag if one has not been sent' do
        expect(sms).to receive(:deliver_welcome_message).with(no_args)

        current_app.update!(welcome_sms_sent: false)

        expect do
          put :update, params: { step: valid_params }
        end.to change { current_app.reload.welcome_sms_sent }
      end

      it 'does not send an SMS otherwise' do
        expect(sms).not_to receive(:deliver_welcome_message)

        expect do
          put :update, params: { step: valid_params }
        end.not_to change { current_app.reload.welcome_sms_sent }
      end

      it 'redirects to the next step' do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to('/steps/introduction-home-address')
      end
    end

    it 'renders edit if the step is invalid' do
      put :update, params: { step: { phone_number: '1111111111' } }

      expect(assigns(:step)).to be_an_instance_of(IntroductionContactInformation)
      expect(response).to render_template(:edit)
    end
  end
end
