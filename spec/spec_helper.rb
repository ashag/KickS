require 'rubygems'
require 'sequel'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

RSpec.configure do |config|
  config.around(:each) do |example| 
    Sequel::DATABASES.first.transaction do 
      example.run 
      raise Sequel::Error::Rollback 
    end
  end 
end