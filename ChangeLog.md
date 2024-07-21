### 0.1.0 / 2024-07-22

* Initial release:
  * Provides a web interface to explore and search the
    [ronin database][ronin-db].
  * Allows managing [ronin-repos] from the web interface.
  * Allows listing and building the built-in or installed 3rd-party
    [payloads][ronin-payloads].
  * Allows listing installed 3rd-party [exploits][ronin-exploits].
  * Supports automating [nmap] and [masscan] scans and importing their results
    into the [ronin database][ronin-db].
  * Supports automating [spidering websites][ronin-web-spider] and importing all
    visited URLs into the [ronin database][ronin-db].
  * Supports performing recon using [ronin-recon] and importing all discovered
    hostnames, IPs, and URLs into [ronin database][ronin-db].
  * Supports testing URLs for web vulnerabilities using [ronin-vulns].

[sqlite]: https://sqlite.org/
[redis]: https://redis.io/
[nmap]: https://nmap.org/
[masscan]: https://github.com/robertdavidgraham/masscan#readme

[Ruby]: https://www.ruby-lang.org/
[dry-types]: https://dry-rb.org/gems/dry-types/
[dry-schema]: https://dry-rb.org/gems/dry-schema/
[dry-validation]: https://dry-rb.org/gems/dry-validation/

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-nmap]: https://github.com/ronin-rb/ronin-nmap#readme
[ronin-masscan]: https://github.com/ronin-rb/ronin-masscan#readme
[ronin-web-spider]: https://github.com/ronin-rb/ronin-web-spider#readme
[ronin-recon]: https://github.com/ronin-rb/ronin-recon#readme
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
