Sequel.connect('sqlite://test.db')

class Project < Sequel::Model
  plugin :validation_helpers
  one_to_many :funds
  one_to_one :user

  def validate
    super
    validates_presence [:name, :target_amount]
    validates_unique :name, :message=> ' => Project name already exists'
    validates_min_length 4, :name, :message=> ' => Project name can\'t be shorter than 4 characters'
    validates_max_length 20, :name, :message=> ' => Project name can\'t be longer than 20 characters'
    validates_format (/^(\$)?(\d+)(\.|,)?\d{0,2}?$/), :target_amount, :message=> '=> Incorrect currency format'
  end

  def self.funded_amount(project)
    project = Project.where(name: project).first
    project.funds.inject(0){|total, n| total + n.backed_amount}
  end
end
