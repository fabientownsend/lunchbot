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


``` bash
new menu www.new_menu.com // will set the url of the new menu
```

The current menu url can be then asked by the user.

``` bash
menu? // will return the url of the menu
```

## Order
User can order their meal, for each meal ordered the bot will confirm the
order.

``` bash
order me: burger
```

You can also ask what meal has been ordered by a person. Note that if the
person isn't in the channel or didn't order anything, the bot will not reply.

``` bash
order: @name_of_the_person
```

You can display all the orders
``` bash
all orders?
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
order -name of the guest-: his meal
```

## Remind
Thid command will remind all the people that didn't order their meal.
The people displayed are those in the channel without any meal and
the added customer without a meal.

``` bash
remind
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
