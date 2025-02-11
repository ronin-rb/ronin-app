# frozen_string_literal: true
source 'https://rubygems.org'

gemspec

# gem 'ruby-masscan', '~> 0.3', github: 'postmodern/ruby-masscan',
#                               branch: 'main'

# NOTE: do not auto-load gems which are meant to be executed at runtime
gem 'puma',    require: false
gem 'sidekiq', require: false

#
# Ronin dependencies
#
gem 'ronin-support',    '~> 1.2', github: 'ronin-rb/ronin-support',
                                  branch: '1.2.0'
gem 'ronin-core',       '~> 0.3', github: 'ronin-rb/ronin-core',
                                  branch: '0.3.0'
# gem 'ronin-db',         '~> 0.2', github: 'ronin-rb/ronin-db',
#                                   branch: 'main'

# gem 'ronin-db-activerecord', '~> 0.2', github: 'ronin-rb/ronin-db-activerecord',
#                                        branch: 'main'

gem 'ronin-payloads',   '~> 0.3', github: 'ronin-rb/ronin-payloads',
                                  branch: '0.3.0'
gem 'ronin-exploits',   '~> 1.2', github: 'ronin-rb/ronin-exploits',
                                  branch: '1.2.0'
gem 'ronin-vulns',      '~> 0.3', github: 'ronin-rb/ronin-vulns',
                                  branch: '0.3.0'
# gem 'ronin-web-spider', '~> 0.2', github: 'ronin-rb/ronin-web-spider',
#                                   branch: 'main'
# gem 'ronin-recon',      '~> 0.1', github: 'ronin-rb/ronin-recon'
# gem 'ronin-nmap',       '~> 0.1', github: 'ronin-rb/ronin-nmap'
# gem 'ronin-masscan',    '~> 0.1', github: 'ronin-rb/ronin-masscan'
# gem 'ronin-repos',      '~> 0.2', github: 'ronin-rb/ronin-repos',
#                                   branch: 'main'

group :development do
  gem 'rake', require: false
  gem 'rack-test',        '~> 2.1', require: false

  gem 'rubygems-tasks',   '~> 0.2'

  gem 'rspec',            '~> 3.0', require: false
  gem 'simplecov',        '~> 0.20', require: false
  gem 'capybara',         '~> 3.40', require: false

  gem 'kramdown',         '~> 2.0', require: false
  gem 'kramdown-man',     '~> 1.0', require: false

  gem 'redcarpet',        require: false, platform: :mri
  gem 'yard',             '~> 0.9', require: false
  gem 'yard-spellcheck',  require: false

  gem 'dead_end',         require: false
  gem 'sord',             require: false, platform: :mri
  gem 'stackprof',        require: false, platform: :mri
  gem 'rubocop',          require: false, platform: :mri
  gem 'rubocop-ronin',    require: false, platform: :mri

  gem 'foreman',          '~> 0.80', require: false
end
