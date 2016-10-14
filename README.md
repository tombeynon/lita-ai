# lita-ai

[![Gem Version](https://badge.fury.io/rb/lita-ai.svg)](https://badge.fury.io/rb/lita-ai)
[![Build Status](https://travis-ci.org/tombeynon/lita-ai.png?branch=master)](https://travis-ci.org/tombeynon/lita-ai)
[![Coverage Status](https://coveralls.io/repos/tombeynon/lita-ai/badge.svg?branch=master&service=github)](https://coveralls.io/github/tombeynon/lita-ai?branch=master)

A Lita handler like no other; this makes Lita respond to any unhandled messages using Cleverbot.

What does that mean?

![Example of a conversation with Lita](https://raw.github.com/tombeynon/lita-ai/master/example.png)

## Installation

Add lita-ai to your Lita instance's Gemfile:

``` ruby
gem 'lita-ai'
```

## Configuration

Sign up at [cleverbot.io](http://cleverbot.io) and enter your api user and key into lita_config.rb.

```
config.handlers.ai.api_user = '<redacted>'
config.handlers.ai.api_key = '<redacted>'
```


## Usage

Just send a message mentioning your robot by it's name or alias, either directly as a command or anywhere else in the message.

```
> lita what's up?
#=> Not much, I baked brownies today.

> could I have some lita?
#=> Sure, when and where?
```

Your robots name will be stripped from the message we send to Cleverbot.. we don't want to confuse it anymore than it already is.

## License

[MIT](http://opensource.org/licenses/MIT)
