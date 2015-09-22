require 'wisper/activejob/broadcaster/version'
require 'wisper'

module Wisper
  module Broadcasters
    class ActiveJobBroadcaster
      def broadcast(subscriber, _publisher, event, args)
        subscriber.class.perform_later(event, args)
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
