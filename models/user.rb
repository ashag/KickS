Sequel.connect('sqlite://test.db')

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :projects
  one_to_many :funds

  def validate
    super
    validates_presence :name
    validates_unique :name, :message=> 'User name is taken'
    validates_unique :credit_card
    validates_max_length 19, :credit_card, :message=> ' => Invalid credit card'
  end
end