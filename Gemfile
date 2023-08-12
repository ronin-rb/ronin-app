# frozen_string_literal: true
source 'https://rubygems.org'

gemspec

gem 'ruby-masscan', '~> 0.3', github: 'postmodern/ruby-masscan',
                              branch: '0.3.0'

gem 'puma',    require: false
gem 'foreman', require: false

#
# Ronin dependencies
#
# gem 'ronin-support',    '~> 1.0', github: 'ronin-rb/ronin-support'
gem 'ronin-core',       '~> 0.2', github: 'ronin-rb/ronin-core',
                                  branch: '0.2.0'
gem 'ronin-db',         '~> 0.2', github: 'ronin-rb/ronin-db',
                                  branch: '0.2.0'

gem 'ronin-db-activerecord', '~> 0.2', github: 'ronin-rb/ronin-db-activerecord',
                                       branch: '0.2.0'

gem 'ronin-payloads',   '~> 0.1', github: 'ronin-rb/ronin-payloads'
# gem 'ronin-exploits',   '~> 1.0', github: 'ronin-rb/ronin-exploits'
# gem 'ronin-vulns',      '~> 0.1', github: 'ronin-rb/ronin-vulns'
gem 'ronin-web',        '~> 1.0', github: 'ronin-rb/ronin-web'
gem 'ronin-web-spider', '~> 0.2', github: 'ronin-rb/ronin-web-spider',
                                  branch: '0.2.0'
gem 'ronin-recon',      '~> 0.1', github: 'ronin-rb/ronin-recon'
gem 'ronin-nmap',       '~> 0.1', github: 'ronin-rb/ronin-nmap'
gem 'ronin-masscan',    '~> 0.1', github: 'ronin-rb/ronin-masscan'
gem 'ronin-repos',      '~> 0.2', github: 'ronin-rb/ronin-repos',
                                  branch: '0.2.0'

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
