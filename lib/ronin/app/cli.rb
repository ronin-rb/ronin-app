# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023-2024 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-app is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-app is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ronin-app.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/core/cli/command'
require 'ronin/core/cli/logging'
require 'ronin/db/config_file'

require 'command_kit/options/version'
require 'command_kit/open_app'
require 'command_kit/env/path'

require_relative 'root'
require_relative 'version'

module Ronin
  module App
    #
    # Starts the ronin web app.
    #
    # ## Usage
    #
    #     ronin-app [options]
    #
    # ## Options
    #
    #     -V, --version                    Prints the version and exits
    #     -H, --host IP                    The host to listen on (Default: localhost)
    #         --db NAME                    The ronin-db database to connect to
    #         --db-uri URI                 The ronin-db database URI to connect to
    #     -p, --port PORT                  The port to listen on (Default: 1337)
    #     -h, --help                       Print help information
    #
    # @api private
    #
    class CLI < Core::CLI::Command

      include Core::CLI::Logging
      include CommandKit::Options::Version
      include CommandKit::OpenApp
      include CommandKit::Env::Path

      command_name 'ronin-app'

      option :host, short: '-H',
                    value: {
                      type:    String,
                      usage:   'IP',
                      default: 'localhost'
                    },
                    desc: 'The host to listen on'

      option :port, short: '-p',
                    value: {
                      type:    Integer,
                      usage:   'PORT',
                      default: 1337
                    },
                    desc: 'The port to listen on'

      option :db, value: {
                    type:  DB::ConfigFile.load.keys,
                    usage: 'NAME'
                  },
                  desc: 'The ronin-db database to connect to'

      option :db_uri, value: {
                        type:  String,
                        usage: 'URI'
                      },
                      desc: 'The ronin-db database URI to connect to'

      description 'Starts the ronin web app'

      man_dir File.join(ROOT,'man')
      man_page 'ronin-app.1'

      version VERSION

      #
      # Runs the `ronin-app` command.
      #
      def run
        host = options[:host]
        port = options[:port]

        pids = []

        # switch to the app directory
        Dir.chdir(ROOT)

        begin
          if is_valkey_installed?
            unless is_valkey_running?
              log_info "Starting Valkey server ..."
              pids << start_valkey
              sleep 1
            end
          else
            unless is_redis_running?
              log_info "Starting Redis server ..."
              pids << start_redis
              sleep 1
            end
          end

          # start the web server process
          log_info "Starting Web server on #{host}:#{port} ..."
          pids << start_web_server
          sleep 1

          # start the sidekiq process
          log_info "Starting Sidekiq ..."
          pids << start_sidekiq
          sleep 1

          open_app_for("http://#{host}:#{port}") if stdout.tty?
          sleep
        ensure
          pids.each do |pid|
            Process.kill('TERM',pid)
            Process.kill('HUP',pid)
          end

          Process.waitall
        end
      end

      #
      # Determines if the Redis server is running.
      #
      # @return [Boolean]
      #   Specifies whether the `redis-server` process is running or not.
      #
      def is_redis_running?
        !`pgrep redis-server`.empty?
      end

      #
      # Determines if the Valkey server is running.
      #
      # @return [Boolean]
      #   Specifies whether the `valkey-server` process is running or not.
      #
      def is_valkey_running?
        !`pgrep valkey-server`.empty?
      end

      #
      # Determines if the Valkey server is installed.
      #
      # @return [Boolean]
      #   Specifies whether the `valkey-server` is installed or not.
      #
      def is_valkey_installed?
        command_installed?('valkey-server')
      end

      #
      # Starts the Redis server.
      #
      # @return [Integer]
      #   The PID of the `redis-server` process.
      #
      def start_redis
        Process.spawn('redis-server')
      end

      #
      # Starts the Valkey server.
      #
      # @return [Integer]
      #   The PID of the `valkey-server` process.
      #
      def start_valkey
        Process.spawn('valkey-server')
      end

      #
      # Starts the web server process.
      #
      # @return [Integer]
      #   The PID of the `puma` web server process.
      #
      def start_web_server
        command = %w[puma -C ./config/puma.rb -e production]
        command << '-b' << "tcp://#{options[:host]}:#{options[:port]}"

        Process.spawn(app_env,*command)
      end

      #
      # Starts the sidekiq background job process.
      #
      # @return [Integer]
      #   The PID of the `sidekiq` process.
      #
      def start_sidekiq
        Process.spawn(app_env,"sidekiq -C ./config/sidekiq.yml -e production -r ./config/sidekiq.rb -r ./workers.rb")
      end

      #
      # The environment variables Hash for the app processes.
      #
      # @return [Hash{String => String}]
      #   The env Hash to pass into the app processes.
      #
      def app_env
        env = {}

        if options[:db_uri]
          env['DATABASE_URL'] = options[:db_uri]
        elsif options[:db]
          env['DATABASE_NAME'] = options[:db].to_s
        end

        return env
      end

    end
  end
end
