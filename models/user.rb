Sequel.connect('sqlite://test.db')

class User < Sequel::Model
  one_to_many :funds
  one_to_one :user
end