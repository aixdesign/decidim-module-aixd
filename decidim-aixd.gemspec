# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "decidim/aixd/version"

Gem::Specification.new do |spec|
  spec.name    = "decidim-aixd"
  spec.version = Decidim::AIXD::VERSION
  spec.authors = ["AIxDesign", "Vera Rojman"]
  spec.email   = ["vrojman@protonmail.com"]

  spec.summary     = "AI-powered features for Decidim."
  spec.description = <<~DESC
    Provider-agnostic summarization, translation and transcription for Decidim.
    Supports OpenAI/Deepseek, Anthropic Claude, and Ollama (self-hosted).
    Includes a web form at /aixd/summarize to try it directly.
  DESC

  spec.homepage = "https://github.com/aixdesign/decidim-module-aixd"
  spec.license  = "AGPL-3.0"

  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "README.md"
  ]

  spec.add_dependency "decidim-core", ">= 0.28.0", "< 0.32.0"
  spec.add_dependency "ruby-openai",  ">= 6.0"
  spec.add_dependency "anthropic",    ">= 0.3"

  spec.add_development_dependency "decidim",     ">= 0.28.0", "< 0.32.0"
  spec.add_development_dependency "decidim-dev", ">= 0.28.0", "< 0.32.0"
end
