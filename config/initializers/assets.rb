# frozen_string_literal: true

Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile +=
  %w(michigan-benefits/administrate-extensions.css)
