# LunchBot
A ruby slack bot that assists you when ordering your lunch.

[![Build Status](https://travis-ci.org/willcurry/LunchBot.svg?branch=master)](https://travis-ci.org/willcurry/LunchBot)
[![Coverage Status](https://coveralls.io/repos/github/willcurry/LunchBot/badge.svg?branch=master)](https://coveralls.io/github/willcurry/LunchBot?branch=master)

# Configuring
You have to set these enviorment variables to the ones you have on Slack.

``` bash
export SLACK_CLIENT_ID="XXXX.XXXX"
export SLACK_API_SECRET="XXXX"
export SLACK_VERIFICATION_TOKEN="XXXX"
export SLACK_REDIRECT_URI="XXXX"
```

# Slack
## Menu
User can set a url to the new menu, this will alert all the user present in the
channel about the new menu url.

This command is only for the foreman

``` bash
new menu www.new_menu.com
// will set the url of the new menu
```

The current menu url can be then asked by the user.

``` bash
menu?
// will return the url of the menu
```

## Order
User can order their own meal, for each meal ordered the bot will confirm the
order.

``` bash
order: burger
```

You can also ask what meal has been ordered by a person. Note that if the
person isn't in the channel or didn't order anything, the bot will not reply.

``` bash
order: @name_of_the_person
```

You can order the same meal than someone else
``` bash
copy order: @name_of_the_person
```

You can set youself out for the meal with
``` bash
out
```

You can display all the orders of the current week.
``` bash example
all orders?

// example of return
James Bond: burger
Harry Potter: fish
```

You can have the total sort by kind of food
``` bash example
all food orders

// willl return
burger: 5
fish: 3
```

## Guest
Here are all the interaction with the guest

You can add a guest
``` bash
add guest: Harry Potter
```

You can remove a guest
``` bash
remove guest: Harry Potter
```

You can place an order for a guest
``` bash
order -name of the guest-: some food
```

## Remind
Thid command will remind all the people that didn't order their meal.
The people displayed are those in the channel without any meal and
the hosts of customer without a meal.

This command is only for the foreman

``` bash
remind
```

This can also send the list in private message with this command
``` bash
remind private
```

## Foreman
User can ask who is in charge of the meal with the foreman command.

``` bash
foreman
```

Set the next person as the foreman of the week
``` bash
next foreman
```

You can yourself in the list of the foremans
``` bash
add apprentice
```

###

Development

You can add a new command with
``` bash
ruby ./bin/command_creator.rb
```

this will create a command with the method need in: `lib/commands` and its test in `spec/commands`

To make your new command effective you simply need to add your class to `lib/request_parser`
