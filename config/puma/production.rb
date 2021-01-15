# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
workers Integer(ENV['WEB_CONCURRENCY'] || 0)

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
# The default is "0, 16".
threads Integer(ENV['WEB_THREADS_MIN'] || 0),
        Integer(ENV['WEB_THREADS_MAX'] || 16)

rackup DefaultRackup

directory File.expand_path('.')

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
preload_app!

before_fork { Sequel::DATABASES.each(&:disconnect) }
