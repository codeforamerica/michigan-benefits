class Views::Steps::LegalAgreement < Views::Base
  include Rails.application.routes.url_helpers

  def content
    div class: "card legal-agreement" do
      p "LEGAL"

      ul do
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
        li "Change the legal agreement"
      end
    end
  end
end
