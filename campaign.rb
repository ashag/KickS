#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'
require 'yaml'


program :version, '0.0.1'
program :description, 'KickS projects'

command :project do |c|
  c.syntax = 'project <project_name> <creator_name> <target_amount>'
  c.description = 'Creates a new project'
  c.action do |args, options|
    require_relative 'kicks'
    error = YAML.load_file("constants.yml")

    raise error[:missing_argument] unless args[0] && args[1] && args[2]
     
    if validate_target_amount(args[2]) != nil
      target_amount = remove_dollar_symbol(args[2])
    else
      raise error[:incorrect_currency]
    end
    
    begin
      creator = User.find_or_create(name: args[1])
      project = Project.create(name: args[0], user_id: creator.id, target_amount: target_amount)
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
    error = YAML.load_file("constants.yml")

    raise error[:missing_argument] unless args[0] 

    project = Project.find(name: args[0])

    raise error[:proj_not_found] if !project

    project.funds.each do |p|
      puts "#{p.user.name} backed for $#{p.backed_amount}"
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

command :myprojects do |c|
  c.syntax = 'myprojects <creator_name>'
  c.description = 'Lists creator projects'
  c.action do |args, options|
    require_relative 'kicks'
    error = YAML.load_file("constants.yml")

    raise error[:missing_argument] unless args[0]
    
    creator = User.find(name: args[0])

    raise error[:no_user] if !creator
    
    projects = Project.where(user_id: creator.id)
    puts "#{creator.name} has #{projects.count} project(s):"
    
    projects.each do |p|
      puts "- #{p.name}"
    end
  end
end

def remove_dollar_symbol(dollars)
  dollars.split('$').last
end

def validate_target_amount(dollars)
  # valid formats $.90, $900.00, $9000, 900.00
  dollars =~ /^(\$)?(\d+|\.)(\.)?\d{0,2}?$/
end

