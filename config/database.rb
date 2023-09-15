# frozen_string_literal: true
require 'ronin/db'

database = if    ENV['DATABASE_URL']  then ENV['DATABASE_URL']
           elsif ENV['DATABASE_NAME'] then ENV['DATABASE_NAME'].to_sym
           else                            :default
           end

pool_size = if ENV['DB_POOL'] then ENV['DB_POOL'].to_i
            else                   4
            end

Ronin::DB.connect(database, pool: pool_size)
