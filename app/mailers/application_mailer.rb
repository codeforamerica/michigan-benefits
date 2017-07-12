# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@codeforamerica.org'
  layout 'mailer'
end
