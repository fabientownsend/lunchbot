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
User can set a url to the new menu, this will alert all the user present in the
channel about the new menu url.

``` bash
new menu www.new_menu.com // will set the url of the new menu
```

The current menu url can be then asked by the user.

``` bash
menu? // will return the url of the menu
```

