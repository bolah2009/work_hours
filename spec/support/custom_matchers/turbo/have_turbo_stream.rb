module TurboMatchers
  module HaveTurboStream
    RSpec::Matchers.define :have_turbo_stream do |action, target|
      match do |actual|
        turbo_stream_media_type?(actual) && has_turbo_stream_tag?(actual, action, target)
      end

      def turbo_stream_media_type?(actual)
        actual.media_type == Mime[:turbo_stream]
      end

      def has_turbo_stream_tag?(actual, action, target)
        actual.body.match(/<turbo-stream action="#{action}" target="#{target}">/)
      end

      diffable
    end
  end
end

RSpec.configure do |config|
  config.include TurboMatchers::HaveTurboStream, type: :request
end
