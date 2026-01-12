# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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

$LOAD_PATH.unshift(File.join(__dir__,'lib'))

require_relative 'config/sidekiq'
require_relative 'config/database'

require_relative 'workers/install_repo'
require_relative 'workers/update_repo'
require_relative 'workers/update_repos'
require_relative 'workers/remove_repo'
require_relative 'workers/purge_repos'

require_relative 'workers/nmap'
require_relative 'workers/masscan'
require_relative 'workers/import'
require_relative 'workers/spider'
require_relative 'workers/recon'
require_relative 'workers/vulns'
