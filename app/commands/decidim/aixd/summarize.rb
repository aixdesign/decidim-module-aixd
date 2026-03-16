# frozen_string_literal: true

module Decidim
  module AIXD
    class Summarize < Decidim::Command
      DEFAULT_PROMPT = "Summarize the following text concisely."

      # @param text      [String] the text to summarize
      # @param locale    [Symbol] target locale for the summary
      # @param max_length [Integer, nil] optional character cap
      # @param prompt    [String] optional custom system prompt
      def initialize(text:, locale: I18n.locale, max_length: nil, prompt: "")
        @text       = text
        @locale     = locale
        @max_length = max_length
        @prompt     = prompt
      end

      def call
        result = Decidim::AIXD.provider.summarize(
          source:     @text,
          locale:     @locale,
          max_length: @max_length,
          prompt:     @prompt.presence || DEFAULT_PROMPT
        )
        broadcast(:ok, result)
      rescue Decidim::AIXD::ProviderError => e
        broadcast(:error, e.message)
      end
    end
  end
end
