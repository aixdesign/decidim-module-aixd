# frozen_string_literal: true

module Decidim
  module AIXD
    class Configuration
      attr_accessor :default_provider, :providers

      def initialize
        @default_provider = :openai
        @providers        = {}
      end

      def provider
        name  = @default_provider
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
          raise ArgumentError, "Unknown provider: #{name}. Valid options: openai, deepseek, anthropic, ollama"
        end
      end
    end
  end
end
