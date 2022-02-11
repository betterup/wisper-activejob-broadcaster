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
        return subscriber.send("perform_#{event}?", *args) if subscriber.respond_to?("perform_#{event}?", true)

        true
      rescue StandardError
        raise DispatchError.new(subscriber, event, args)
      end

      class DispatchError < StandardError
        def initialize(subscriber, event, args)
          super("Unable to perform #{name(subscriber)}##{event}(#{args_info(args)})")
        end

        private

        # Copied from LoggerBroadcaster
        def name(object)
          id_method  = %w(id uuid key object_id).find do |method_name|
            object.respond_to?(method_name) && object.method(method_name).arity <= 0
          end
          id         = object.send(id_method)
          class_name = object.class == Class ? object.name : object.class.name
          "#{class_name}##{id}"
        end

        def args_info(args)
          return if args.empty?

          args.map do |arg|
            arg_string = name(arg)
            arg_string += ": #{arg.inspect}" if [Numeric, Array, Hash, String].any? {|klass| arg.is_a?(klass) }
            arg_string
          end.join(', ')
        end
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
