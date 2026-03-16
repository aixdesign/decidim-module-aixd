# frozen_string_literal: true

module Decidim
  module AIXD
    module Providers
      class Base
        def initialize(**options)
          @options = options
        end

        def summarize(source:, locale:, max_length: nil, prompt: "")
          raise NotImplementedError, "#{self.class}#summarize is not implemented"
        end

        private

        def api_key
          @options[:api_key]
        end

        def build_prompt(custom_prompt, instruction, source)
          parts = []
          parts << custom_prompt if custom_prompt.present?
          parts << instruction
          parts << ""
          parts << source
          parts.join("\n")
        end
      end
    end
  end
end
