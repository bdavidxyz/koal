class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 5
    Rails.logger.info "Hello world"
  end
end
