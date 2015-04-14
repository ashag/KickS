Sequel.connect('sqlite://test.db')

class Project < Sequel::Model
  one_to_many :funds
  one_to_one :user

  def self.funded_amount(project)
    project = Project.where(name: project).first
    project.funds.inject(0){|total, n| total + n.backed_amount}
  end
end
