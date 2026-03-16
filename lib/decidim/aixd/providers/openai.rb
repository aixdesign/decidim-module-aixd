# frozen_string_literal: true

module Decidim
  module AIXD
    module Providers
      class OpenAI < Base
        DEFAULT_MODEL = "gpt-4o"

        def summarize(source:, locale:, max_length: nil, prompt: "")
          length_hint = max_length ? "in #{max_length} characters or fewer" : ""
          user_msg = build_prompt(prompt, "Summarize the following text #{length_hint} in #{locale}:", source)
          chat(user_msg)
        end

        private

        def client
          require "openai"
          @client ||= ::OpenAI::Client.new(
            access_token: api_key,
            **client_options
          )
        end

        def client_options
          opts = {}
          opts[:uri_base] = @options[:uri_base] if @options[:uri_base]
          opts
        end

        def chat(user_message)
          response = client.chat(
            parameters: {
              model:    @options.fetch(:model, DEFAULT_MODEL),
              messages: [
                { role: "system", content: "You are a helpful assistant for a civic participation platform." },
                { role: "user",   content: user_message }
              ]
            }
          )
          response.dig("choices", 0, "message", "content")&.strip
        rescue ::OpenAI::Error => e
          raise Decidim::AIXD::ProviderError, "OpenAI request failed: #{e.message}"
        end
      end
    end
  end
end
