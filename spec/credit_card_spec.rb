require 'spec_helper'
require 'credit_card'

describe CreditCard do


  describe 'check_valid_card' do
    describe 'invalid card numbers' do 
      it 'returns -1 if credit on file' do
        card = CreditCard.new("4417123456789112")
        User.create(name: "h", credit_card: "4417123456789112")
        expect(card.check_valid_card).to eq(-1)
      end

      it 'returns -2 if card numbers are not all integers' do 
        cards = CreditCard.new("4417123456789ff2")
        expect(cards.check_valid_card).to eq(-2)
      end
    end

    describe 'valid card numbers' do
      let(:good_card) { CreditCard.new("4408041234567893") }
      let(:bad_card) { CreditCard.new("4417123456789112") }  
      
      context 'validate_card_numbers' do 
        it 'will parse the correct credit card type' do 
          expect(good_card.verify_card_type).to eq("Visa")
        end

        it 'verify_luhn' do 
          expect(good_card.verify_luhn).to eq true
        end

        it 'validate_card_numbers' do 
          expect(good_card.validate_card_numbers).to eq true
          expect(bad_card.validate_card_numbers).to eq false
        end
      end
    end 
  end

end