Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_payload do |controller|
    {
      application_id: controller.try(:current_application).try(:id),
      application_type: controller.try(:current_application).try(:class),
      admin_user_email: controller.try(:current_admin_user).try(:email),
    }
  end
end
