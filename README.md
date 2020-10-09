# Deploy Button API

## ABOUT

This project was created to be an generic and agnostic environment deploy button, it can deploy to multiple servers(16 limit) in different build conditions, that also may handle different languages in the same device.

The trick here is to delegate all the complexity of the environments to an API running on your local machine, so the device itself only need to build a request based upon your choises and the API will handle it by matching a ENV that has the command to deploy in the environment that you have chose when the button was triggered. And how probably you already have those dependencies and accesses in your machine it wont be concern at all.

The device code and build instructions can be found in: [deploy_button_esp8266](https://github.com/the-harry/deploy_button_esp8266).

## INSPIRATION

This project was inspired in few others deploys buttons that already exists, but I'd like to express my very special thanks to my teacher Thiago Chierici Cunha, that introduced me into this topic.
Few deploy buttons that have been used as inspiration are:

* [AWS IOT Button](https://aws.amazon.com/pt/iotbutton/)

* [DIY ARDUINO MICRO DEPLOY BUTTON](https://medium.com/@gregorkas/tutorial-a-simple-arduino-deploy-button-dbf6f7289427)

* [DIY ARDUINO UNO DEPLOY BUTTON - JS BASED](https://github.com/niallo/arduino-deploybutton)

* [This amazing deploy button box](https://www.chau.cc/the-deploy-button)

* [Also this one with similar lock mechanism](https://jamesonmccowan.com/2015/05/04/a-deploy-button/)

* [This Raspi deploy button](https://www.youtube.com/watch?v=m6V1PNkpMgg)

* [And this one](https://www.youtube.com/watch?v=T9xG2MaeNV4&t=156s)

* [Other raspi deploy button](https://www.losant.com/blog/build-a-two-man-launch-switch-with-a-raspberry-pi-3-and-losant)

* [And this verry cool briefcase deploy button](https://www.952studios.com/office-fun/launchbox-a-raspberrypi-powered-deployment-button/)

And many others...

Using a raspberrypi is cool, but expensive, using and arduino as a keyboard is also cool, but I need a device with HID support, and not all boards suports it, furthermore, it would be more dificult to deal with warnings, since they are shown upon the request response code, so the cheapest way to achieve this is using an esp8266 sending a post request to the API that makes the deploy itself.
Other problem is that most of this deploy buttons only deploy to a single environment, some due the language that it was built, or due to mechanical incapability, or even comercial reasons. That said, the main ideia of this project is to create a free open source deploy button that can deploy to any environment, using any language, in any plataform!

## How it works

When the device is triggered, it sends a post request to the API in your LAN with the payload: `{environment: NIBBLE}`, a [nibble](https://en.wikipedia.org/wiki/Nibble) is 4 bits long value, and it can be naturally mapped to an hex char, so if you send 0000, it will be converted to `0`, if you send 1111 it will be converted to `f`, that said we can deploy to 16 different environments.

This is used to map each nibble to one environment, this is acomplished by using environment vars, in this format: `RECIPE_<NIBBLE>`, e.g. `RECIPE_f`, and this var value must match a recipe name under `/opt/deploy_button/recipes`. The recipe will contain all commands needed to deploy the application, its just a shell script. More about recipes down below.

So for example, if you have a recipe called `heroku_staging` under `/opt/deploy_button/recipes` and you want this to be the environment `0` you can set a env like so:

```bash
export RECIPE_0=heroku_staging
```

So when you hit the button with the dipswitch with the value `0000` this deploys will be triggered.

## Install

Make sure you have ruby 2.7.1 installed.

```bash
# clone the repo into opt dir
git clone https://github.com/the-harry/deploy_button_api.git /opt/deploy_button

# install gems
cd /opt/deploy_button && bundle install && cd -

# add the env `API_KEY` with the same key you used in the device
export API_KEY=mystrongkeythatnoonewilleverguess

# Start the api
rackup /opt/deploy_api/config.ru -o 0.0.0.0 -p 6666 & disown
```

You can kill the server by running:

```bash
kill $(ps aux | grep puma | grep 6666 | awk '{print $2}')
```

## RECIPES

The concept of recipe here are similar to the one used in Chef, but instead of beeing in ruby it's pure shell script. This aproach was choose because it's easyer to simple add the commands that you are used to do in a script than writing all from beginig in other language. And since the API is running on your machine it's mostly likely that you will already have all credentials needed and the dependencies.

Lets create a recipe to deploy an heroku app:

First create a file named `staging_heroku` under `/opt/deploy_button/recipes`:

```bash
touch `/opt/deploy_button/recipes/staging_heroku`
```

Inside this file we can add the commands that we usually do manually:

```bash
#!/bin/bash

cd ~/workspace/project_dir

git stash && git switch master && git pull && git push heroku master:master && git switch - && git stash pop
wall 'Deploy done'
```

After saving the file add a env for this recipe, in this case this will be the recipe F or 1111(binary):

```bash
export RECIPE_f=staging_heroku
```
