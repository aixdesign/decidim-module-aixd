# frozen_string_literal: true

module Decidim
  module AIXD
    class Configuration
      FEATURES = %i[
        summarization
        translation
        transcription
        tagging
        topic_detection
        key_questions
      ].freeze

      attr_accessor :default_provider,
                    :summarization_provider,
                    :translation_provider,
                    :transcription_provider,
                    :tagging_provider,
                    :topic_detection_provider,
                    :key_questions_provider,
                    :providers,
                    :features

      def initialize
        @default_provider = :openai
        @providers        = {}
        @features         = FEATURES.each_with_object({}) do |f, h|
          h[f] = { enabled_by_default: true }
        end
        @features[:transcription] = { enabled_by_default: false }
      end

      def provider_for(feature)
        name  = public_send(:"#{feature}_provider") || @default_provider
        klass = provider_class(name)
        opts  = @providers.fetch(name.to_sym, {})
        klass.new(**opts)
      end

      private

      def provider_class(name)
        case name.to_sym
        when :openai, :deepseek then Decidim::AIXD::Providers::OpenAI
        when :anthropic         then Decidim::AIXD::Providers::Anthropic
        when :ollama            then Decidim::AIXD::Providers::Ollama
        else
          raise ArgumentError, "Unknown AI provider: #{name}. Valid options: openai, deepseek, anthropic, ollama"
        end
      end
    end
  end
end
