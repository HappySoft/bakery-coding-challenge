# frozen_string_literal: true

RSpec.describe PacksCalculator do
  subject(:calculator) { described_class.new }

  describe '#divide_into_packs' do
    example do
      actual_packs = calculator.divide_into_packs(10, [3, 5])
      expect(actual_packs).to match(5 => 2)
    end

    example do
      actual_packs = calculator.divide_into_packs(14, [2, 5, 8])
      expect(actual_packs).to match(8 => 1, 2 => 3).or match(5 => 2, 2 => 2)
    end

    example do
      actual_packs = calculator.divide_into_packs(13, [3, 5, 9])
      expect(actual_packs).to match(5 => 2, 3 => 1)
    end

    it 'returns nothing if given number of items can not be divided into packs' do
      actual_packs = calculator.divide_into_packs(4, [3, 5])
      expect(actual_packs).to be_nil
    end
  end
end
