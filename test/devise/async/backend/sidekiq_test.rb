require "test_helper"

module Devise
  module Async
    module Backend
      describe "Sidekiq" do
        it "enqueues job" do
          Sidekiq.expects(:perform_async).with(:mailer_method, "User", 123)
          Sidekiq.enqueue(:mailer_method, "User", 123)
        end

        it "delegates to devise mailer when delivering" do
          user = create_user
          ActionMailer::Base.deliveries = []
          Backend::Sidekiq.new.perform(:confirmation_instructions, "User", user.id)
          ActionMailer::Base.deliveries.size.must_equal 1
        end
      end
    end
  end
end
