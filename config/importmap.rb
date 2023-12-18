# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
