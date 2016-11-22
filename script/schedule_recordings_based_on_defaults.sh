#!/bin/sh
# This script is supposed to be run by launchd early each Sunday morning.
# It uses the rake task default_services:generate to build new Tasks
# one for each ServiceTime default entry which is both active and in
# the future.
#

# source /Users/churchadministration/.rvm/environments/ruby-2.2.0@rails420

rake default_services:generate RAILS_ENV=production

exit 0
