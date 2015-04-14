require 'rubygems'
require 'sequel'

DB = Sequel.sqlite('test.db')

DB.create_table :users do
  primary_key :id
  String :name
  String :credit_card
end

DB.create_table :funds do
  primary_key :id
  Integer :project_id
  Integer :user_id
  Float :backed_amount
end


DB.create_table :projects do
  primary_key :id
  String :name
  Integer :user_id
  Float :target_amount
  Float :backed_amount
end