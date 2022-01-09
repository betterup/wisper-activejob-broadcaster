require 'wisper/activejob/broadcaster/version'
require 'wisper'

module Wisper
  module Broadcasters
    class ActiveJobBroadcaster
      def broadcast(subscriber, _publisher, event, args)
        subscriber.class.perform_later(event, args) if perform?(subscriber, event, args)
      end

      private

      def perform?(subscriber, event, args)
        # If a predicate method of the format "event_name?" is defined on the subscriber, only run
        # the subscriber if it evaluates to true
        return subscriber.send("#{event}?", *args) if subscriber.respond_to?("#{event}?")

        true
      end
    end
  end

  module ActiveJob
    module Subscriber
      # proxy calls from the generic activejob "perform" method
      # to the specific wisper event listener
      def perform(event, args)
        send(event, *args)
      end
    end
  end
end
