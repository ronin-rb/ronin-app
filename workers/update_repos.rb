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

require 'sidekiq'
require 'ronin/repos'

module Workers
  #
  # A worker that updates all [ronin repos][ronin-repos].
  #
  # [ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
  #
  class UpdateRepos

    include Sidekiq::Worker

    sidekiq_options queue: :repos, retry: false, backtrace: true

    def perform
      Ronin::Repos.cache_dir.update
    end

  end
end
