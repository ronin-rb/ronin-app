# Contributing

* Typo, spelling mistake, and CSS fixes are welcomed and appreciated.
* Please develop against [Ruby] 3.1.x.
* Please make sure new code passes `bundle exec rubocop` style checking.
* Please write tests for all new code and make sure they pass.

## What is NOT allowed

* HAML, Slim, and other HTML templating engines are NOT allowed.
  Please use regular [ERB] that renders [HTML5].
* SASS/SCSS are NOT allowed. Only use vanilla [CSS4].
* JavaScript frameworks are NOT allowed. This means NO React, Angular, Svelte,
  etc. Only use [vanilla ES6 JavaScript][vanilla.js].
* JavaScript packers/compilers are NOT allowed. This means no Babel or Webpack. 
  All JavaScript must be loaded directly or via [import maps].
* No external assets. All images, CSS, and JavaScript must be vendored in
  `public/stylesheets/` or `public/javascript/` so that the app can be used
  offline.
* No Rails dependencies. While we do use [ActiveRecord] for [ronin-db],
  I prefer to avoid using [activesupport] or any other Rails dependencies to
  keep the codebase as lightweight and simple as possible. Instead look for
  [dry-rb] or [sinatra-] alternatives.

[Ruby]: https://www.ruby-lang.org/
[ERB]: https://docs.ruby-lang.org/en/3.1/ERB.html
[HTML5]: https://dev.w3.org/html5/spec-LC/
[CSS4]: https://developer.mozilla.org/en-US/docs/Web/CSS
[vanilla.js]: http://vanilla-js.com/
[import maps]: https://github.com/WICG/import-maps#readme
[ActiveRecord]: https://guides.rubyonrails.org/active_record_basics.html
[activesupport]: https://www.rubydoc.info/gems/activesupport
[dry-rb]: https://www.dry-rb.org/
[sinatra-]: https://rubygems.org/search?query=sinatra-
