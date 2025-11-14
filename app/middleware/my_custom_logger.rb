# app/middleware/my_custom_logger.rb

class MyCustomLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    status, headers, body = @app.call(env)

    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration = ((finish - start) * 1000).round(2)

    Rails.logger.info "⏱ RCAD Middleware Time: #{duration} ms"

    [status, headers, body]
  end
end
