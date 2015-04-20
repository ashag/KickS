class CreditCard 
  def initialize(card_numbers)
    @card_numbers = card_numbers
    @error = YAML.load_file("constants.yml")
  end

  def check_valid_card
    if credit_on_file > 0
      abort @error[:dup_card]
    end

    if !verify_numeric
      abort @error[:card_syntax]
    end

    if @card_numbers.length > 19 
      abort @error[:invalid_card]
    end

    verify_luhn
  end

  def credit_on_file
    User.where(credit_card: @card_numbers).count
  end

  def verify_numeric
    Integer(@card_numbers) rescue false
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