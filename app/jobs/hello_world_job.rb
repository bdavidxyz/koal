class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # :nocov:
    sleep 5
    Rails.logger.info "Hello world"
    # :nocov:
  end
end
