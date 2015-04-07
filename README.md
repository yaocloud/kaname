# Kaname

[![Build Status](https://secure.travis-ci.org/hsbt/kaname.png)](https://travis-ci.org/hsbt/kaname)

Kaname(要) is configuration management tool of Keystone.

## Installation

Install it yourself as:

    $ gem install kaname

## Usage

You can define keystone configuration for OpenStack via YAML format. Like following syntax.

```yaml
antipop:
  email: "antipop@example.com"
  password: "awesome-password"
  tenants:
    production: "cto"
hsbt:
  email: "hsbt@example.com"
  password: "awesome-password"
  tenants:
    development: "admin"
    production: "member"
```

You need to run following command.

```sh
$ kaname diff # You can see difference of definition
$ kaname apply # You can apply configuration into OpenStack
```

You can create user and user's role with tenant

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kaname/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
