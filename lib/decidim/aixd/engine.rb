# frozen_string_literal: true

require "rails/engine"

module Decidim
  module AIXD
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::AIXD
      engine_name "decidim_aixd"

      routes do
        get  "summarize",       to: "summaries#new",    as: :new_summary
        post "summarize",       to: "summaries#create",  as: :summary

        namespace :account do
          resource :ai_preferences, only: %i[edit update]
        end
      end

      initializer "decidim_aixd.autoload", before: :load_config_initializers do
        Rails.autoloaders.each do |loader|
          loader.inflector.inflect("aixd" => "AIXD")
        end
      end

      initializer "decidim_aixd.configure" do
        # Host apps configure via config/initializers/decidim_aixd.rb:
        #
        #   Decidim::AIXD.configure do |config|
        #     config.default_provider = :anthropic
        #     config.providers = {
        #       anthropic: { api_key: ENV["ANTHROPIC_API_KEY"] },
        #       openai:    { api_key: ENV["OPENAI_API_KEY"] },
        #       ollama:    { base_url: "http://localhost:11434", model: "llama3.2" }
        #     }
        #   end
      end

      initializer "decidim_aixd.mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::AIXD::Engine, at: "/aixd", as: :decidim_aixd
        end
      end
    end
  end
end
