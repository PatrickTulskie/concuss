# Concuss

[![Gem Version](https://badge.fury.io/rb/concuss.svg)](https://badge.fury.io/rb/concuss)
[![Build Status](https://github.com/patricktulskie/concuss/actions/workflows/main.yml/badge.svg)](https://github.com/patricktulskie/concuss/actions/workflows/main.yml)

## What is it?

Concuss is a tool for banging against a url with a bunch of different headers to look for potential vulnerabilities.

It works by sending a custom or a random string to a webserver for a specific url in a variety of headers to see if it's able to get that string to appear on the page. If so, you'll get a HIT and you can evaluate that header to see if it's useful for some kind of XSS, cache poisoning, or some other form of injection from malformed headers.

Often times web app and framework developers assume that headers from the client are not malicious or manipulated and will just write them out to the page in one form or another. This project is a specialized tool to find instances of this so that they can be fixed before they are abused.

## What it is NOT.

Concuss is not a tool for automating vulnerabilities, nor should it be used to certify that a page is safe from vulnerabilities. It should not be used on applications or website that you do not personally have permission to scan.

Sending malformed headers to a site can potentially cause errors, crashing, and other damage that I am not responsible for as a result of any usage of this tool. You agree to use this tool at your own risk.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add concuss

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install concuss

## Usage

Primarily, you'll want to use it as a CLI like so:

```
concuss http://localhost:4567
concuss http://localhost:4567 -h non_standard
```

See `concuss --help` for more usage details.

While concuss is designed to be used as a command line tool, you can also include it in your own custom application like so:

```
require 'concuss'

concuss = Concuss.new(url: 'http://localhost:4567', file: 'header_file.txt', header_set: :standard, test_string: "OOGABOOGA")
concuss.attack!
```

This will spit out the results, which isn't super useful if you need to post process them... I'll work on that though.

## Demo

There is a sample app with a vulnerability to test with in the `vuln_app` directory. It takes the contents of `X-CSRF-Token` and spits them out blindly.

Run it for testing like this:

```
docker build vuln_app -t vuln_app
docker run -p 4567:4567 vuln_app
```

Then from the command line, or from another docker container, you should be able to run

```concuss http://localhost:4567 -h non_standard```

...and you'll see a HIT at the bottom.

## Development

After checking out the repo, run `script/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `script/console` for an interactive prompt that will allow you to experiment.

If you add features or fix bugs, please write specs and open up a PR.

Note: Concuss was designed to easily install on most systems with ruby 3+. As such, its only dependencies are in the ruby standard library.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patricktulskie/concuss

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
