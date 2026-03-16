# frozen_string_literal: true

require "spec_helper"

RSpec.describe Decidim::AIXD::UserConsent do
  # All tests use the database — the test app has the migration applied.

  let(:user) { create(:user) }

  describe ".opted_out?" do
    context "when no record exists" do
      it "returns false" do
        expect(described_class.opted_out?(user:, feature: :translation)).to be false
      end
    end

    context "when a record exists with opted_out: false" do
      before { create(:decidim_aixd_user_consent, user:, feature: "translation", opted_out: false) }

      it "returns false" do
        expect(described_class.opted_out?(user:, feature: :translation)).to be false
      end
    end

    context "when a record exists with opted_out: true" do
      before { create(:decidim_aixd_user_consent, user:, feature: "translation", opted_out: true) }

      it "returns true" do
        expect(described_class.opted_out?(user:, feature: :translation)).to be true
      end
    end
  end

  describe ".toggle!" do
    context "when no record exists" do
      it "creates a record with opted_out: true" do
        consent = described_class.toggle!(user:, feature: :translation)
        expect(consent.opted_out).to be true
      end
    end

    context "when a record with opted_out: false exists" do
      before { create(:decidim_aixd_user_consent, user:, feature: "translation", opted_out: false) }

      it "flips to opted_out: true" do
        consent = described_class.toggle!(user:, feature: :translation)
        expect(consent.opted_out).to be true
      end
    end

    context "when a record with opted_out: true exists" do
      before { create(:decidim_aixd_user_consent, user:, feature: "translation", opted_out: true) }

      it "flips to opted_out: false" do
        consent = described_class.toggle!(user:, feature: :translation)
        expect(consent.opted_out).to be false
      end
    end
  end

  describe "validations" do
    it "rejects an unknown feature name" do
      consent = described_class.new(user:, feature: "nonexistent", opted_out: false)
      expect(consent).not_to be_valid
      expect(consent.errors[:feature]).to be_present
    end

    it "enforces uniqueness of user + feature" do
      create(:decidim_aixd_user_consent, user:, feature: "translation", opted_out: false)
      duplicate = described_class.new(user:, feature: "translation", opted_out: true)
      expect(duplicate).not_to be_valid
    end
  end
end
