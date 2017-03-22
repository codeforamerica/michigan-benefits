class Views::Steps::IntroductionComplete < Views::Base
  def content
    h4 "What happens next?"

    p <<~TEXT
      We'll ask you about the people in your household, their citizenship or 
      immigration status, income, and expenses to help us determine eligibility 
      as quickly as possible.
    TEXT
  end
end
