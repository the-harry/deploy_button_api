# Deploy Button API

## ABOUT

This project was created to be an generic and agnostic environment deploy button, it can deploy to multiple servers(16 limit) in different build conditions, that also may handle different languages in the same API.

You need to first add a env with the name of your

## SETTING RECIPES

Before starting your server change the `echo DEPLOY` command inside `Server.rb` for the command to deploy in your environment:

* Heroku example:

`git push origin master:master`

Since it is running on your machine it will already have all credentials.

## GETTING STARTED

* Install deps:

```bash
bundle install
```

* Start the server:

```bash
rackup config.ru -o 0.0.0.0 -p 6666
```


## TODO
# deploy_button_esp8266
