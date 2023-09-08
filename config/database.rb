# frozen_string_literal: true
require 'ronin/db'

database = if    ENV['DATABASE_URL']  then ENV['DATABASE_URL']
           elsif ENV['DATABASE_NAME'] then ENV['DATABASE_NAME'].to_sym
           else                            :default
           end

Ronin::DB.connect(database)
