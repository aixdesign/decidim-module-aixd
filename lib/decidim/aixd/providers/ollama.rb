# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module Decidim
  module AIXD
    module Providers
      class Ollama < Base
        DEFAULT_MODEL = "llama3.2"

        def summarize(source:, locale:, max_length: nil, prompt: "")
          return NotImplementedError # This is a draft, not tested yet

          length_hint = max_length ? "in #{max_length} characters or fewer" : ""
          chat(build_prompt(prompt, "Summarize the following text #{length_hint} in #{locale}:", source))
        end

        private

        def base_url
          @options.fetch(:base_url, "http://localhost:11434")
        end

        def model
          @options.fetch(:model, DEFAULT_MODEL)
        end

        def chat(content)
          response = post("/api/chat", {
                            model:    model,
                            messages: [{ role: "user", content: content }],
                            stream:   false
                          })
          response.dig("message", "content")&.strip
        end

        def post(path, body)
          uri     = URI("#{base_url}#{path}")
          http    = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
          request.body = body.to_json

          response = http.request(request)
          JSON.parse(response.body)
        rescue StandardError => e
          raise Decidim::AIXD::ProviderError, "Ollama request failed: #{e.message}"
        end
      end
    end
  end
end
