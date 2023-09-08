# frozen_string_literal: true
require 'ronin/db'

Ronin::DB.connect(ENV['DATABASE_URL'] || :default)
