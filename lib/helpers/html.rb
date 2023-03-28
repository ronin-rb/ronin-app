# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (C) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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

require 'rack/utils'

module Helpers
  #
  # HTML helper methods.
  #
  module HTML
    #
    # Escapes the text as HTML text.
    #
    # @param [String] text
    #   The string to escape.
    #
    # @return [String]
    #   The HTML escaped string.
    #
    def h(text)
      Rack::Utils.escape_html(text) if text
    end

    #
    # Escapes the text as an HTML attribute value.
    #
    # @param [String] text
    #   The string to escape.
    #
    # @return [String]
    #   The escaped HTML attribute.
    #
    def hattr(text)
      Rack::Utils.escape_path(text) if text
    end
  end
end
