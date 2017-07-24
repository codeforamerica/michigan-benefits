Rails.application.config.sorcery.submodules = []

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
    user.encryption_algorithm = :md5 if Rails.env.test?
  end

  config.user_class = "User"
end
