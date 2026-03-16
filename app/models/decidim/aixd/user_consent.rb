# frozen_string_literal: true

module Decidim
  module AIXD
    class UserConsent < ApplicationRecord
      self.table_name = "decidim_aixd_user_consents"

      FEATURES = Decidim::AIXD::Configuration::FEATURES

      belongs_to :user, class_name: "Decidim::User"

      validates :feature,   inclusion: { in: FEATURES.map(&:to_s) }
      validates :user,      uniqueness: { scope: :feature }
      validates :opted_out, inclusion: { in: [true, false] }

      scope :opted_out, -> { where(opted_out: true) }

      def self.opted_out?(user:, feature:)
        where(user:, feature: feature.to_s, opted_out: true).exists?
      end

      def self.toggle!(user:, feature:)
        consent = find_or_initialize_by(user:, feature: feature.to_s)
        consent.opted_out = !consent.opted_out
        consent.save!
        consent
      end
    end
  end
end
