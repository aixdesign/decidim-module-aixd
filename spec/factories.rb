# frozen_string_literal: true

FactoryBot.define do
  factory :decidim_aixd_user_consent, class: "Decidim::AIXD::UserConsent" do
    association :user, factory: :user
    feature { "translation" }
    opted_out { false }
  end
end
