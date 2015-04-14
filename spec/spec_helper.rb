require 'rubygems'
require 'factory_girl'

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

require 'sequel'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.around(:each) do |example| 
    Sequel::DATABASES.first.transaction do 
      example.run 
      raise Sequel::Error::Rollback 
    end
  end 
end