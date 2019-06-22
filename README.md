# LunchBot
A ruby slack bot that assists you when ordering your lunch.

[![Build Status](https://travis-ci.org/fabientownsend/lunchbot.svg?branch=master)](https://travis-ci.org/fabientownsend/lunchbot)
[![Coverage Status](https://coveralls.io/repos/github/fabientownsend/lunchbot/badge.svg?branch=master)](https://coveralls.io/github/fabientownsend/lunchbot?branch=master)

# Add new command
You can add a new command with
``` bash
ruby ./bin/command_creator.rb new command ClassName
```

This will create a command with the method need in: `lib/commands` and its test in `spec/commands`.

To make your new command effective you simply need to add your commands class to the `lib/request_parser`.

## Tests
Run the tests
```
Bundle exec rspec
```

Run the types checking
```
bundle exec srb tc
```

## Coding Conventions
To make the code consistent we ask you to use Rubocop.
Note that Rubocop isn't configured to run on the pipeline, it's up to the
developers to check the code they commit.

Run the static code analyzer
``` bash
Bundle exec rubocop

```
