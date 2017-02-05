# DocDigger

[![Build Status](https://travis-ci.org/wootaw/doc-digger.svg?branch=master)](https://travis-ci.org/wootaw/doc-digger)
[![Gem Version](https://badge.fury.io/rb/doc-digger.png)](http://badge.fury.io/rb/doc-digger)
[![Code Climate](https://codeclimate.com/github/wootaw/doc-digger/badges/gpa.svg)](https://codeclimate.com/github/wootaw/doc-digger)
[![Test Coverage](https://codeclimate.com/github/wootaw/doc-digger/badges/coverage.svg)](https://codeclimate.com/github/wootaw/doc-digger/coverage)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/doc-digger`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'doc-digger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install doc-digger

## Basic Usage

DocDigger is a tool for generating RESTful web API documentation by analyzing block comments. Below is a simple example showing some of the more common features of DocDigger in documenting parts of the Twitter API that created by Grape.

```ruby
module Twitter

=begin
  @doc (twitter) Twitter
    This row is a description of this document.
    Detail: 

    This is document of number one.
    It do not anything. Just to at here. 

    This is the second paragraph of this document description.
    It do not anything, too.
=end
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api

    resource :statuses do
=begin
      @res get /api/v1/statuses/public_timeline Return a public timeline

      @res_return {Object[]} data Status List
      @res_return {String} data.id Status ID
      @res_return {String} data.status Your status
=end
      get :public_timeline do
      end

=begin
      @res get /api/v1/statuses/home_timeline Return a personal timeline
      @res_error (401) msg 401 Unauthorized

      @res_return {Object[]} data Status List
      @res_return {String} data.id Status ID
      @res_return {String} data.status Your status
=end
      get :home_timeline do
      end

=begin
      @res get /api/v1/statuses/:id Return a status
      @res_param {Number} id Status id

      @res_return {String} id Status ID
      @res_return {String} status Your status

      @res_state deprecated
=end
      route_param :id do
        get do
        end
      end

=begin
      @res post /api/v1/statuses Create a status
      @res_param {String} status Your status
      @res_error (401) msg 401 Unauthorized
=end
      post do
      end

=begin
      @res put /api/v1/statuses/:id Update a status
      @res_param {String} id Status ID
      @res_param {String} status Your status
      @res_error (401) msg 401 Unauthorized
=end
      put ':id' do
      end

=begin
      @res delete /api/v1/statuses/:id Delete a status
      @res_param {String} id Status ID
      @res_error (401) msg 401 Unauthorized
      @res_state coming This resource will be coming soon
=end
      delete ':id' do
      end
    end
  end
end
```

## Supported Programming Languages

- Java, JavaScript, C#, Go, Dart, PHP, Scala (all DocStyle capable languages):
```c
/**
 * @doc (twitter) Twitter
 */
```

- ruby
```ruby
=begin
  @doc (twitter) Twitter
=end
```

- perl
```perl
#**
# @doc (twitter) Twitter
#*
```

- python
```python
"""
  @doc (twitter) Twitter
"""
```

- elixir
```elixir
@dd """
  @doc (twitter) Twitter
"""
```

- coffee
```coffee
###
  @doc (twitter) Twitter
###
```

- lua
```lua
--[[
  @doc (twitter) Twitter
]]
```

- erlang
```erlang
%{
%  @doc (twitter) Twitter
%}
```

## Commands



### @doc

| Field | Description |  
| --- | --- |
| name | |  
| summary | |  
| descriptions | |

### @res

### @doc_state and @res_state

### @res_param @res_header @res_response

## Descriptions

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wootaw/doc-digger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
