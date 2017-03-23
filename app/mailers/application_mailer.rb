class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@codeforamerica.org"
  layout 'mailer'
end
