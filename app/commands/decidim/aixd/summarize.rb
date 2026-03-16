# frozen_string_literal: true

module Decidim
  module AIXD
    class Summarize < Decidim::Command
      DEFAULT_PROMPT = "Summarize the following text concisely."

      # @param text      [String] the text to summarize
      # @param locale    [Symbol] target locale for the summary
      # @param max_length [Integer, nil] optional character cap
      # @param prompt    [String] optional custom system prompt
      # @param context   [Object, nil] optional resource context for consent check
      def initialize(text:, locale: I18n.locale, max_length: nil, prompt: "", context: nil)
        @text       = text
        @locale     = locale
        @max_length = max_length
        @prompt     = prompt
        @context    = context
      end

      def call
        return broadcast(:consent_refused) unless ConsentChecker.permitted?(feature: :summarization, context: @context)

        result = Decidim::AIXD.provider_for(:summarization).summarize(
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
