#! /bin/bash

bundle install

ruby database.rb

chmod 755 campaign.rb
chmod 755 back_project.rb