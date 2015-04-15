class CreditCard 
  def initialize(card_numbers)
    @card_numbers = card_numbers
  end

  def check_valid_card
    if credit_on_file > 0
      return -1
    end

    if !verify_numeric
      return -2
    end

    if @card_numbers.length > 19 
      raise "Invalid card"
    end

    verify_luhn
  end

  def credit_on_file
    User.where(credit_card: @card_numbers).count
  end

  def verify_numeric
    Integer(@card_numbers) rescue false
  end

  def validate_card_numbers
    verify_card_type != "Unknown" && verify_luhn
  end

  def verify_luhn
    numbers = ''
    @card_numbers.split('').reverse.each_with_index do |n, i|
      numbers += n if i%2 == 0
      numbers += (n.to_i*2).to_s if i%2 == 1
    end
    
    numbers.split('').inject(0){|total, n| total + n.to_i}%10 == 0
  end
end