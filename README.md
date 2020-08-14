# Deploy Button API

## ABOUT


## CHANGING DEPLOY METHOD

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
