require 'spec_helper'

describe Wisper::Broadcasters::ActiveJobBroadcaster do
  subject(:broadcast) { described_class.new.broadcast(subscriber, nil, :foo, []) }

  let(:subscriber) { subscriber_class.new }
  let(:subscriber_class) do
    Class.new do
      include Wisper::ActiveJob::Subscriber

      def self.perform_later(_event, _args)
        # no-op
      end

      def foo
        # no-op
      end
    end
  end

  it 'has a version number' do
    expect(Wisper::Activejob::Broadcaster::VERSION).not_to be nil
  end

  it 'runs the job' do
    expect(subscriber_class).to receive(:perform_later)
    broadcast
  end

  context 'when defining a predicate' do
    let(:subscriber_class) do
      Class.new do
        include Wisper::ActiveJob::Subscriber

        def self.perform_later(_event, _args)
          # no-op
        end

        def foo
          # no-op
        end

        def foo?
          true
        end
      end
    end

    it 'runs the job' do
      expect(subscriber_class).to receive(:perform_later)
      broadcast
    end

    context 'when the predicate returns false' do
      let(:subscriber_class) do
        Class.new do
          include Wisper::ActiveJob::Subscriber

          def self.perform_later(_event, _args)
            # no-op
          end

          def foo
            # no-op
          end

          def foo?
            false
          end
        end
      end

      it 'skips the job' do
        expect(subscriber_class).not_to receive(:perform_later)
        broadcast
      end
    end
  end
end
