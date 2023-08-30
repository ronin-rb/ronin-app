# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_count = ENV.fetch('PUMA_THREADS',5).to_i
threads threads_count, threads_count

# Default to running on localhost:1337 since this is a local web ap.
bind "tcp://#{ENV.fetch('HOST','localhost')}:#{ENV.fetch('PORT',1337)}"

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch('PUMA_WORKERS',1).to_i
