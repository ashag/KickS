require 'sequel'

Sequel.connect('sqlite://test.db')

class Fund < Sequel::Model
  plugin :validation_helpers
  many_to_one :project
  many_to_one :user

  def validate
    validates_presence [:backed_amount, :project_id, :user_id]
    validates_format (/^(\$)?(\d+)(\.|,)?\d{0,2}?$/), :backed_amount, :message=> '=> Incorrect currency format'
  end
end