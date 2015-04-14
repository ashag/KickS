FactoryGirl.define do
  factory :user do
    name "Waldo"
    credit_card  "4417123456789112"
  end

  # factory :admin, class: User do
  #   first_name "Admin"
  #   last_name  "User"
  #   admin      true
  # end

  factory :project do 
    name "Take over the world"
    target_amount 800
  end
end