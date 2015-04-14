#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'

program :version, '0.0.1'
program :description, 'mini Kickstarter'

command :back do |c|
  require_relative 'user'
  require_relative 'project'

  c.syntax = 'Kickstarter project [options]'
  c.summary = ''
  c.description = 'creates a new project'
  c.example 'description', 'back <project_name> <creator_name> <amount>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    creator = User.find_or_create(name: args[1])

    begin
      project = Project.create(name: args[0], user_id: creator.id, target_amount: args[2])
      put "Added #{project.name} project with target of $#{args[2]}"
    rescue
      puts "Something went wrong. Please try again."
    end
  end
end

command :list do |c|
  require_relative 'project'
  require_relative 'fund'


  c.syntax = 'Kickstarter list [options]'
  c.summary = ''
  c.description = 'lists backers for project'
  c.example 'description', 'list <project_name>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    project = Project.where(name: args[0]).first

    if project
      project.funds.each do |p|
        puts "#{p.user.name} backed for $#{p.backed_amount}"
      end
    else
      puts "#{args[0]} does not exist"
    end

    backed_amount = Project.funded_amount(args[0])
    remaining_amount = project.target_amount - backed_amount 

    if backed_amount > project.target_amount
      puts "#{project.name} is successful!"
    else
      puts "#{project.name} needs $#{remaining_amount} more dollars to be successful"
    end
  end
end

