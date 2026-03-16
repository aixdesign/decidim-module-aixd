# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AIXD
    describe Summarize do
      subject(:command) { described_class.new(**params) }

      let(:provider) { instance_double(Providers::Base) }
      let(:text) { "This is some long text that needs to be summarized." }

      let(:params) { { text: text } }

      before do
        allow(Decidim::AIXD).to receive(:provider).and_return(provider)
      end

      describe "#call" do
        context "when the provider returns a summary" do
          let(:summary) { "Short summary." }

          before do
            allow(provider).to receive(:summarize).and_return(summary)
          end

          it "broadcasts :ok with the summary" do
            expect { command.call }.to broadcast(:ok, summary)
          end

          it "passes the text as source" do
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(source: text))
          end

          it "uses the DEFAULT_PROMPT when no prompt is given" do
            command.call
            expect(provider).to have_received(:summarize).with(
              hash_including(prompt: Summarize::DEFAULT_PROMPT)
            )
          end

          it "uses the current locale" do
            allow(I18n).to receive(:locale).and_return(:en)
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(locale: :en))
          end

          it "passes nil for max_length by default" do
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(max_length: nil))
          end
        end

        context "when a custom prompt is given" do
          let(:params) { { text: text, prompt: "Be very brief." } }
          let(:summary) { "Brief." }

          before { allow(provider).to receive(:summarize).and_return(summary) }

          it "passes the custom prompt to the provider" do
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(prompt: "Be very brief."))
          end
        end

        context "when max_length is given" do
          let(:params) { { text: text, max_length: 100 } }
          let(:summary) { "Short." }

          before { allow(provider).to receive(:summarize).and_return(summary) }

          it "passes max_length to the provider" do
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(max_length: 100))
          end
        end

        context "when a locale is given" do
          let(:params) { { text: text, locale: :ca } }
          let(:summary) { "Resum." }

          before { allow(provider).to receive(:summarize).and_return(summary) }

          it "passes the locale to the provider" do
            command.call
            expect(provider).to have_received(:summarize).with(hash_including(locale: :ca))
          end
        end

        context "when the provider raises a ProviderError" do
          before do
            allow(provider).to receive(:summarize).and_raise(ProviderError, "API unavailable")
          end

          it "broadcasts :error with the error message" do
            expect { command.call }.to broadcast(:error, "API unavailable")
          end
        end
      end
    end
  end
end
