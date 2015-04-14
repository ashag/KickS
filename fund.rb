Sequel.connect('sqlite://test.db')

class Fund < Sequel::Model
  many_to_one :project
  many_to_one :user
end