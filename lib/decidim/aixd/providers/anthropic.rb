# frozen_string_literal: true

module Decidim
  module AIXD
    module Providers
      class Anthropic < Base
        MODEL      = "claude-sonnet-4-6"
        MAX_TOKENS = 4096

        def summarize(source:, locale:, max_length: nil, prompt: "")
          length_hint = max_length ? "in #{max_length} characters or fewer" : ""
          message(build_prompt(prompt, "Summarize the following text #{length_hint} in #{locale}:", source))
        end

        private

        def client
          require "anthropic"
          @client ||= ::Anthropic::Client.new(api_key: api_key)
        end

        def message(content)
          response = client.messages(
            parameters: {
              model:      MODEL,
              max_tokens: MAX_TOKENS,
              system:     "You are a helpful assistant for a civic participation platform.",
              messages:   [{ role: "user", content: content }]
            }
          )
          response.dig("content", 0, "text")&.strip
        rescue ::Anthropic::Error => e
          raise Decidim::AIXD::ProviderError, "Anthropic request failed: #{e.message}"
        end
      end
    end
  end
end
