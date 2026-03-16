# frozen_string_literal: true

require "decidim/dev"

Decidim::Dev.dummy_app_path = File.expand_path(
  File.join("..", "..", "spec", "decidim_dummy_app"),
  __dir__
)

require "decidim/dev/test/base_spec_helper"

require "decidim/aixd"

RSpec.configure do |config|
  config.after do
    Decidim::AIXD.reset_configuration!
  end
end
