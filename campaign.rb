#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'

program :version, '0.0.1'
program :description, 'KickS projects'

command :project do |c|
  c.syntax = 'campaign project [options]'
  c.summary = ''
  c.description = 'creates a new project'
  c.example 'description', 'project <project_name> <creator_name> <target_amount>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    require_relative 'models/user'
    require_relative 'models/project'

    raise "missing argument" unless args[0] && args[1] && args[2]

    creator = User.find_or_create(name: args[1])
    dollars = args[2].split('$').last
    begin
      project = Project.create(name: args[0], user_id: creator.id, target_amount: dollars)
      puts project.target_amount
      puts "Added #{project.name} project with target of $#{project.target_amount}"
    rescue Sequel::ValidationFailed => e
      puts "Error: #{e}"
    end
  end
end

command :list do |c|
  require_relative 'models/project'
  require_relative 'models/fund'
  require_relative 'models/user'


  c.syntax = 'campaign list [options]'
  c.summary = ''
  c.description = 'lists backers for project'
  c.example 'description', 'list <project_name>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    raise "missing argument" unless args[0]
    
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

