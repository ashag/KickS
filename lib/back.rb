require 'yaml'
require_relative '../kicks'


class Back

  def initialize(user, card_numbers, project, backed_amount)
    @backer = User.find_or_create(name: user)
    @card_numbers = card_numbers
    @project = project
    @backed_amount = backed_amount

    @error = load_messages
 
    abort @error[:incorrect_currency] if validate_backed_amount == nil
  end

  def load_messages
    YAML.load_file("constants.yml")
  end

  def check_card
    CreditCard.new(@card_numbers).check_valid_card
    update_user_card
  end

  def validate_backed_amount
    # valid formats 0.10, 10.00, 100.00, 100
    @backed_amount =~ /^\d+(\d+|\.)(\.)?\d{0,2}?$/
  end

 def update_user_card
   begin
      @backer.update(credit_card: @card_numbers)
      process_fund
   rescue => e
     raise "Error: #{e}"
   end
 end

  def process_fund
   begin
     Fund.create(project_id: @project.id, user_id: @backer.id, backed_amount: @backed_amount)
     puts "#{@backer.name} backed project #{@project.name} for $#{@backed_amount}"
   rescue Sequel::ValidationFailed => e
     puts "Error: #{e}"
   rescue => e
     puts @error[:oops]
   end 
  end
end
