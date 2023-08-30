# ronin-app 1 "2023-08-30" Ronin App "User Manuals"

## SYNOPSIS

`ronin-app` [*options*] [*COMMAND*]

## DESCRIPTION

Starts the local Ronin web application.

## OPTIONS

`-H`, `--host` *IP*
  The IP address to listen on. Defaults to `localhost` if not specified.

`-p`, `--port` *PORT*
  The port to listen on. Defaults to `1337` if not specified.

`-V`, `--version`
  Prints the `ronin-app` version.

`-h`, `--help`
  Prints help information.

## ENVIRONMENT

*HOME*
  Alternate location for the user's home directory.

*XDG_CONFIG_HOME*
  Alternate location for the `~/.config` directory.

*XDG_DATA_HOME*
  Alternate location for the `~/.local/share` directory.

## FILES

`~/.local/share/ronin-db/database.sqlite3`
  The default sqlite3 database file.

`~/.config/ronin-db/database.yml`
  Optional database configuration.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

