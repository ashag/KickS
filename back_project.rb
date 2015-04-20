#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'
require 'yaml'
require_relative 'kicks'


program :version, '0.0.1'
program :description, 'KickS back a project'

command :back do |c|
  c.syntax = 'back <user_name> <project_name> <credit card> <backed_amount>'
  c.description = 'Back a project'
  c.action do |args, options|
    require_relative 'kicks'
    require_relative 'lib/back' #load models

    error = YAML.load_file("constants.yml") #load error messages

    abort error[:missing_argument] unless args[0] && args[1] && args[2] && args[3]

    project = Project.find(name: args[1])
    if project.nil?
      abort error[:proj_not_found]
    end

    Back.new(args[0], args[2], project, args[3]).check_card
  end
end

command :backer do |c|
  c.syntax = 'backer <backer_name>'
  c.description = 'Projects that backer has backed'
  c.action do |args, options|
    require_relative 'kicks'
    error = YAML.load_file("constants.yml")

    raise error[:missing_argument] unless args[0] 

    backer = User.find(name: args[0])

    if backer 
      backed = Fund.where(user_id: backer.id)
    else 
      abort error[:no_user]
    end

    if backed.count > 0
      backed.each do |b|
        puts "Backed #{b.project.name} for $#{b.backed_amount}"
      end
    else
      puts "#{backer.name} has not backed a project"
    end
  end
end
