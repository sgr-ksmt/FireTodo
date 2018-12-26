#!/bin/sh
cd `dirname $0`
cd ../
gem install bundler -N
bundle install --path vendor/bundle
bundle exec pod install