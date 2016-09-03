#!/bin/bash

bundle exec rake generate
bundle exec rake deploy
git add --all
git commit -m "green gerong blog"
git push origin source