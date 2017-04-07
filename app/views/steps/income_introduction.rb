class Views::Steps::IncomeIntroduction < Views::Base
  def content
    slab_with_card do
      p <<~TEXT
        In the next section, we will ask you for information about money you 
        receive and valuable things you may own.
      TEXT

      small_text do
        b <<~TEXT
          This information is key to determine the benefits you're household is 
          eligible for.
        TEXT
      end

      help_text <<~TEXT
        If you aren't sure about exact numbers right now — that's okay. 
        Do your best and we will work with you to clarify later.
      TEXT
    end
  end
end
