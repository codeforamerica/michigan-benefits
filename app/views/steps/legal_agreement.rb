# frozen_string_literal: true

class Views::Steps::LegalAgreement < Views::Base
  def content
    div class: 'card legal-agreement' do
      section class: 'legal' do
        list 'Summary' do
          list_item 'You have been honest on this application.'
          list_item 'You agree to the terms of the privacy policy'
          list_item 'Getting benefits will not affect your or your family’s immigration status. Immigration information is private and confidential.'
        end

        list 'Details' do
          list_item 'My answers to the questions are true and complete to the best of my knowledge.'
          list_item 'I understand that giving false or misleading statements or misrepresenting, hiding or withholding facts to establish eligibility is fraud. Fraud can cause a criminal case to be filed against me and/or I may be barred for a period of time (or life) from getting benefits.'
          list_item 'I understand that illegally using or trafficking food assistance benefits is subject to the same penalties as above.'
          list_item 'I understand that Social Security Numbers or immigration status for household members applying for benefits may be shared with the appropriate government agencies as required by federal law.'
        end
      end
    end
  end

  def list(title)
    h3 title
    ul class: 'list--bulleted text--small' do
      yield
    end
  end

  def list_item(text)
    li do
      span text
    end
  end
end
