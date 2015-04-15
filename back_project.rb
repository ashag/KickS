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
    require_relative 'kicks' #load models

    error = YAML.load_file("constants.yml") #load error messages

    raise error[:missing_argument] unless args[0] && args[1] && args[2] && args[3]

    project = find_project(args[1])
    if project.nil?
      puts error[:proj_not_found]
      exit
    end

    if validate_backed_amount(args[3]) != nil
      check_card(args[0], args[2], args[3], project) 
    else
      raise error[:incorrect_currency]
    end
  end
end

command :backer do |c|
  c.syntax = 'backer <backer_name>'
  c.description = 'Projects that backer has backed'
  c.action do |args, options|
    require_relative 'kicks'
    error = YAML.load_file("constants.yml")

    raise error[:missing_argument] unless args[0] 

    backer = find_backer(args[0])

    if backer 
      backed = Fund.where(user_id: backer.id)
    else 
      raise error[:no_user]
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


def error
  YAML.load_file("constants.yml")
end

def validate_backed_amount(dollars)
  # valid formats 0.10, 10.00, 100.00, 100
  dollars =~ /^\d+(\d+|\.)(\.)?\d{0,2}?$/
end

def find_backer(user)
  User.find(name: user)
end

def find_project(project)
  Project.find(name: project)
end

def update_user_card(backer, card_numbers)
  begin
    backer.update(credit_card: card_numbers)
  rescue => e
    abort puts "Error: #{e}"
  end
end

def check_card(user,card_numbers,backed_amount,project)
  CreditCard.new(card_numbers).check_valid_card
  backer = User.find_or_create(name: user)
  update_user_card(backer,card_numbers) 
  process_fund(backer,backed_amount,project)
end

def process_fund(backer,backed_amount,project)
  begin
    Fund.create(project_id: project.id, user_id: backer.id, backed_amount: backed_amount)
    puts "#{backer.name} backed project #{project.name} for $#{backed_amount}"
  rescue Sequel::ValidationFailed => e
    puts "Error: #{e}"
  rescue => e
    puts "Error: #{e}"
    puts error[:oops]
  end 
end
