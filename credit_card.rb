class CreditCard 

  def initialize(card_numbers)
    @card_numbers = card_numbers
  end

  def check_valid_card
    if credit_on_file > 0
      return -1
    end

    if !verify_integers
      return -2
    end

    validate_card_numbers
  end

  def credit_on_file
    User.where(credit_card: @card_numbers).count
  end

  def verify_integers
    Integer(@card_numbers) rescue false
  end

  def validate_card_numbers
    verify_card_type != "Unknown" && verify_luhn
  end

  def verify_card_type
    length = @card_numbers.size
    if length == 15 && @card_numbers =~ /^(34|37)/
      "AMEX"
    elsif length == 16 && @card_numbers =~ /^6011/
      "Discover"
    elsif length == 16 && @card_numbers =~ /^5[1-5]/
      "MasterCard"
    elsif (length == 13 || length == 16) && @card_numbers =~ /^4/
      "Visa"
    else
      "Unknown"
    end
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