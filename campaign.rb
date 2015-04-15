#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'


program :version, '0.0.1'
program :description, 'KickS projects'

command :project do |c|
  c.syntax = 'project <project_name> <creator_name> <target_amount>'
  c.description = 'Creates a new project'
  c.action do |args, options|
    require_relative 'kicks'

    raise "missing argument" unless args[0] && args[1] && args[2]
  
    creator = User.find_or_create(name: args[1])
    dollars = args[2].split('$').last
    
    begin
      project = Project.create(name: args[0], user_id: creator.id, target_amount: dollars)
      puts "Added #{project.name} project with target of $#{project.target_amount}"
    rescue Sequel::ValidationFailed => e
      puts "Error: #{e}"
    end
  end
end

command :list do |c|
  c.syntax = 'list <project_name>'
  c.description = 'Lists backers for project'
  c.action do |args, options|
    require_relative 'kicks'

    raise "missing argument" unless args[0]

    project = Project.where(name: args[0]).first

    if project
      project.funds.each do |p|
        puts "#{p.user.name} backed for $#{p.backed_amount}"
      end
    else
      puts "#{args[0]} does not exist"
      exit
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

