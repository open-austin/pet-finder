worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|

  # start the sidekiq process and watch it below - we need to make sure
  # if the worker process dies that we kill our master process, which will
  # automatically reboot the dyno
  # thanks to: https://coderwall.com/p/fprnhg/free-background-jobs-on-heroku#comment_6332
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2 -q notifier -q default")

  t = Thread.new {
    Process.wait @sidekiq_pid
    puts "Worker died. Bouncing unicorn."
    Process.kill 'QUIT', Process.pid
  }
  # Just in case
  t.abort_on_exception = true

  # Handle kill signals from Heroku (they send TERM instead of QUIT)
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # handle sidekiq 
  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { size: 5 }
  end

  # Handle kill signals from Heroku (they send TERM instead of QUIT)
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end