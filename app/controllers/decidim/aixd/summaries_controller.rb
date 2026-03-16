# frozen_string_literal: true

module Decidim
  module AIXD
    class SummariesController < Decidim::ApplicationController
      def new; end

      def create
        Decidim::AIXD::Summarize.call(
          text:   params[:text],
          locale: params[:locale].presence || I18n.locale,
          prompt: params[:prompt]
        ) do
          on(:ok)    { |result| @summary = result }
          on(:error) { |msg|    @error   = msg }
        end
      end
    end
  end
end
