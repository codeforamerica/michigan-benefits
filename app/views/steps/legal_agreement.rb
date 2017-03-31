class Views::Steps::LegalAgreement < Views::Base
  def content
    div class: "card legal-agreement" do

      text <<~HTML.html_safe
        <section class="legal">
          <h3>Summary</h3>
          <ul class="list--bulleted text--small">
            <li>You have been honest on this application.</li>
            <li>You agree to the terms of the privacy policy</li>
            <li>Getting benefits will not affect your or your family’s immigration status. Immigration information is private and confidential.</li>
          </ul>
          <h3>Details</h3>
          <p>I understand that by signing this application under penalty of perjury (making false statements), that:</p>
          <ul class="list--bulleted text--small">
            <li>My answers to the questions are true and complete to the best of my knowledge.</li>
            <li>I understand that giving false or misleading statements or misrepresenting, hiding or withholding facts to establish eligibility is fraud. Fraud can cause a criminal case to be filed against me and/or I may be barred for a period of time (or life) from getting benefits.</li>
            <li>I understand that illegally using or trafficking food assistance benefits is subject to the same penalties as above.</li>
            <li>I understand that Social Security Numbers or immigration status for household members applying for benefits may be shared with the appropriate government agencies as required by federal law.</li>
          </ul>
        </section>
      HTML
    end
  end
end


