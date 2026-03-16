# frozen_string_literal: true

require "spec_helper"

RSpec.describe Decidim::AIXD::ConsentChecker do
  describe ".permitted?" do
    subject(:permitted) { described_class.permitted?(feature: feature, context: context, user: user) }

    let(:feature)  { :summarization }
    let(:context)  { nil }
    let(:user)     { nil }

    context "when the feature is enabled at platform level" do
      before do
        Decidim::AIXD.configure do |c|
          c.features = { summarization: { enabled_by_default: true } }
        end
      end

      it { is_expected.to be true }
    end

    context "when the feature is disabled at platform level" do
      before do
        Decidim::AIXD.configure do |c|
          c.features = { summarization: { enabled_by_default: false } }
        end
      end

      after { Decidim::AIXD.reset_configuration! }

      it { is_expected.to be false }
    end

    context "when context has a component with the feature disabled" do
      let(:component_settings) do
        double("settings").tap do |s|
          allow(s).to receive(:respond_to?).with(:ai_summarization_enabled).and_return(true)
          allow(s).to receive(:ai_summarization_enabled).and_return(false)
        end
      end

      let(:component) { double("component", settings: component_settings) }
      let(:context)   { double("resource", component: component) }

      before do
        Decidim::AIXD.configure do |c|
          c.features = { summarization: { enabled_by_default: true } }
        end
      end

      it { is_expected.to be false }
    end

    context "when context has a component with the feature enabled" do
      let(:component_settings) do
        double("settings").tap do |s|
          allow(s).to receive(:respond_to?).with(:ai_summarization_enabled).and_return(true)
          allow(s).to receive(:ai_summarization_enabled).and_return(true)
        end
      end

      let(:component) { double("component", settings: component_settings) }
      let(:context)   { double("resource", component: component) }

      it { is_expected.to be true }
    end
  end
end
