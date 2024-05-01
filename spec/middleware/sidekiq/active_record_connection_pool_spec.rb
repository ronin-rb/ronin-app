require 'spec_helper'
require 'middleware/sidekiq/active_record_connection_pool'

describe Middleware::Sidekiq::ActiveRecordConnectionPool do
  describe "#call" do
    let(:worker) { double('Worker') }
    let(:job)    { double('job') }
    let(:queue)  { double('queue') }

    it "must yield then call ActiveRecord::Base.connection_handler.clear_active_connections!" do
      expect(ActiveRecord::Base.connection_handler).to receive(:clear_active_connections!)

      expect { |b|
        subject.call(worker,job,queue,&b)
      }.to yield_control
    end

    context "when the block raises an exception" do
      let(:message)   { "error!" }
      let(:exception) { RuntimeError.new(message) }

      it "must still call ActiveRecord::Base.connection_handler.clear_active_connections!" do
        expect(ActiveRecord::Base.connection_handler).to receive(:clear_active_connections!)

        expect {
          subject.call(worker,job,queue) do
            raise(exception)
          end
        }.to raise_error(exception)
      end
    end

    context "when ActiveRecord::Base.connection_handler.clear_active_connections! raises an exception" do
      let(:message)   { "ActiveRecord error!" }
      let(:exception) { RuntimeError.new(message) }

      it "must print the error message to stderr" do
        expect(ActiveRecord::Base.connection_handler).to receive(:clear_active_connections!).and_raise(exception)

        expect { |b|
          subject.call(worker,job,queue,&b)
        }.to yield_control.and(output("#{message}#{$/}").to_stderr)
      end
    end
  end
end
