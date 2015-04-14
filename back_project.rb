#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'sequel'

program :version, '0.0.1'
program :description, 'back project'

command :back do |c|
  require_relative 'user'
  require_relative 'project'
  require_relative 'fund'
  require_relative 'credit_card'

  c.syntax = 'Back project back [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'back <user_name> <project_name> <credit card> <backed_amount>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    project = Project.find(name: args[1])
    if project.nil?
      puts "That project does not exist"
      exit
    end 

    case CreditCard.new(args[2]).check_valid_card
    when -1 
      puts "ERROR: That card has already been added by another user!"
    when -2
      puts "We cannot process your card. Please check the numbers."
    when false
      puts "ERROR: This card is invalid"
    else
      begin
        backer = User.find_or_create(name: args[0])
        backer.update(credit_card: args[2])
        Fund.create(project_id: project.id, user_id: backer.id, backed_amount: args[3])
        puts "#{backer.name} backed project #{project.name} for $#{args[3]}"
      rescue
        puts "Something went wrong. We're sorry for the inconvenience. Please try again."
      end 
    end  
  end
end

command :backer do |c|
  require_relative 'user'
  require_relative 'project'
  require_relative 'fund'

  c.syntax = 'Back project backer [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'backer <backer_name>'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
      backer = User.find(name: args[0])

      if backer 
        backed = Fund.where(user_id: backer.id)
      else 
        puts "No user by that name"
      end

      if backed
        backed.each do |b|
          puts "Backed #{backed.project.name} for $#{backed.backed_amount}"
        end
      end
  end
end

