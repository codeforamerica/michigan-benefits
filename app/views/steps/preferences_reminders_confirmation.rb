class Views::Steps::PreferencesRemindersConfirmation < Views::Base
  needs :f

  def content
    slab_with_card do
      question f, :email, "What's the best email address for you?" do
        text_field f, :email, "E-mail address"
      end
    end
  end
end
