# frozen_string_literal: true

module Decidim
  module AIXD
    module Account
      class AiPreferencesController < Decidim::ApplicationController
        include Decidim::UserProfile

        before_action :authenticate_user!

        def edit
          @consents = current_user_consents
        end

        def update
          Decidim::AIXD::Configuration::FEATURES.each do |feature|
            opted_out = params.dig(:ai_preferences, feature.to_s) != "1"
            consent   = Decidim::AIXD::UserConsent.find_or_initialize_by(
              user:    current_user,
              feature: feature.to_s
            )
            consent.update!(opted_out: opted_out)
          end

          flash[:notice] = t("decidim.aixd.account.ai_preferences.updated")
          redirect_to edit_account_ai_preferences_path
        end

        private

        def current_user_consents
          Decidim::AIXD::Configuration::FEATURES.index_with do |feature|
            consent = Decidim::AIXD::UserConsent.find_by(user: current_user, feature: feature.to_s)
            consent ? !consent.opted_out : true
          end
        end
      end
    end
  end
end
