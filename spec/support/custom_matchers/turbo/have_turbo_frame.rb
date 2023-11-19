module TurboMatchers
  module HaveTurboFrame
    RSpec::Matchers.define :have_turbo_frame do |expected|
      match do |actual|
        actual.match(/<turbo-frame id="#{expected}">/)
      end

      description do
        "have a turbo frame with id #{expected}"
      end

      diffable
    end
  end
end

RSpec.configure do |config|
  config.include TurboMatchers::HaveTurboFrame, type: :request
end
