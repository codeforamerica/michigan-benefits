class Views::AccountsMailer::ResetPasswordEmail < Views::EmailBase
  needs :account
  needs :url

  def content
    full_row {
      td {
        h6 {
          text "Hi "
          text(account.email)
          text ","
        }

        p {
          text "We received a request to change your Citizen Code password. To do this, please "
          link_to "follow this link", url
          text "."
        }

        p "If you didn't try to change your password, please disregard this email."

        p "Sincerely,"

        p "Citizen Code"
      }
    }
  end
end
