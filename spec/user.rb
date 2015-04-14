Sequel.connect('sqlite://test.db')

class User < Sequel::Model
  # plugin :class_table_inheritance, :class_name_column

  one_to_many :projects
  one_to_many :funds

end