# frozen_string_literal: true
source 'https://rubygems.org'

gem 'ruby-masscan', '~> 0.3', github: 'postmodern/ruby-masscan',
                              branch: '0.3.0'

#
# Ronin dependencies
#
gem 'ronin-support',    '~> 1.0'
gem 'ronin-nmap',       '~> 0.1', github: 'ronin-rb/ronin-nmap'
gem 'ronin-masscan',    '~> 0.1', github: 'ronin-rb/ronin-masscan'
gem 'ronin-repos',      '~> 0.1'
gem 'ronin-db',         '~> 0.2', github: 'ronin-rb/ronin-db',
                                  branch: '0.2.0'

gem 'ronin-db-activerecord', '~> 0.2', github: 'ronin-rb/ronin-db-activerecord',
                                       branch: '0.2.0'

gem 'ronin-payloads',   '~> 0.1'
gem 'ronin-exploits',   '~> 1.0'
gem 'ronin-vulns',      '~> 0.1'
gem 'ronin-web',        '~> 1.0', github: 'ronin-rb/ronin-web'

gem 'dry-schema',       '~> 1.0'
gem 'dry-validation',   '~> 1.0'
gem 'dry-struct',       '~> 1.0'

gem 'redis',            '~> 5.0'
gem 'redis-namespace',  '~> 1.10'

gem 'sinatra',          '~> 3.0'
gem 'sinatra-contrib',  '~> 3.0'
gem 'sinatra-flash',    '~> 0.3'
gem 'puma',             '~> 6.0', require: false

gem 'foreman',          '~> 0.80', require: false
gem 'sidekiq',          '~> 7.0'

group :development do
  gem 'rake', require: false

  gem 'rspec',            '~> 3.0', require: false
  gem 'simplecov',        '~> 0.20', require: false

  gem 'kramdown',         '~> 2.0', require: false

  gem 'redcarpet',        require: false, platform: :mri
  gem 'yard',             '~> 0.9', require: false
  gem 'yard-spellcheck',  require: false

  gem 'dead_end',         require: false
  gem 'sord',             require: false, platform: :mri
  gem 'stackprof',        require: false, platform: :mri
  gem 'rubocop',          require: false, platform: :mri
  gem 'rubocop-ronin',    require: false, platform: :mri
end
