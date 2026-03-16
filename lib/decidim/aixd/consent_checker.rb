# frozen_string_literal: true

module Decidim
  module AIXD
    class ConsentChecker
      def self.permitted?(feature:, context: nil, user: nil)
        new(feature:, context:, user:).permitted?
      end

      def initialize(feature:, context: nil, user: nil)
        @feature = feature.to_sym
        @context = context
        @user    = user
      end

      def permitted?
        platform_enabled? && component_enabled? && !user_opted_out?
      end

      private

      def platform_enabled?
        Decidim::AIXD.configuration.features.dig(@feature, :enabled_by_default) != false
      end

      def component_enabled?
        return true unless @context

        component = @context.try(:component)
        return true unless component&.settings&.respond_to?(:"ai_#{@feature}_enabled")

        component.settings.public_send(:"ai_#{@feature}_enabled")
      end

      def user_opted_out?
        resolved_user = @user || author_of(@context)
        return false unless resolved_user

        Decidim::AIXD::UserConsent.opted_out?(user: resolved_user, feature: @feature)
      end

      def author_of(context)
        context&.try(:author) || context&.try(:creator_author)
      end
    end
  end
end
