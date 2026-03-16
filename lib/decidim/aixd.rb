# frozen_string_literal: true

require "decidim/aixd/version"
require "decidim/aixd/configuration"

require "decidim/aixd/providers/base"
require "decidim/aixd/providers/openai"
require "decidim/aixd/providers/anthropic"
require "decidim/aixd/providers/ollama"

require "decidim/aixd/engine"

module Decidim
  module AIXD
    class Error < StandardError; end
    class ProviderError < Error; end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield configuration
      end

      def provider
        configuration.provider
      end

      def reset_configuration!
        @configuration = Configuration.new
      end
    end
  end
end
