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

        def perform_foo?
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

          def perform_foo?
            false
          end
        end
      end

      it 'skips the job' do
        expect(subscriber_class).not_to receive(:perform_later)
        broadcast
      end
    end

    context 'when the predicate raises an error' do
      let(:subscriber_class) do
        Class.new do
          include Wisper::ActiveJob::Subscriber

          def self.perform_later(_event, _args)
            # no-op
          end

          def foo
            # no-op
          end

          def perform_foo?
            raise 'some error'
          end
        end
      end

      it 'skips the job and raises an error', :aggregate_failures do
        expect(subscriber_class).not_to receive(:perform_later)
        expect { broadcast }.to raise_error(Wisper::Broadcasters::ActiveJobBroadcaster::DispatchError)
      end
    end
  end
end
