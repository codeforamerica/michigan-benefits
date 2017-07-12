# frozen_string_literal: true

require 'spec_helper'

describe FormMailer do
  describe '#submission' do
    around(:each) do |example|
      with_modified_env FORM_RECIPIENT: 'test@example.com' do
        example.run
      end
    end

    let(:form_path) do
      Rails.root.join('lib/assets/form.pdf')
    end

    let(:form) do
      instance_double('Form', fill: form_path)
    end

    it 'should mail to the correct recipient' do
      mail = send_mail

      expect(mail.to).to eq(['test@example.com'])
    end

    it 'should attach the form PDF' do
      mail = send_mail

      expect(mail.attachments.size).to eq(1)
      expect(mail.attachments.first.filename).to eq('application.pdf')
    end

    def send_mail
      FormMailer.submission(form: form).deliver_now
      ActionMailer::Base.deliveries.last
    end
  end
end
