require 'spec_helper'
require 'back'
require 'pry'

describe Back, :focus do
 
  let(:back) { Back.new("asha", "4408041234567893", "music box", "800.00") }
  let(:error) { YAML.load_file("constants.yml") }

  describe 'validates backed amount currency format' do
    describe 'correct currency format' do
      it 'returns 0 if correct' do 
        expect(back.validate_backed_amount).to eq 0
      end
    end

    # describe 'incorrect currency format' do 
    #   let(:wrong_back) { Back.new("asha", "4408041234567893", "music box", ".80000") }
    #   it 'raises incorrect currency error' do
    #     expect(wrong_back.validate_backed_amount).to raise_error
    #     binding.pry
    #   end
    # end
  end


end