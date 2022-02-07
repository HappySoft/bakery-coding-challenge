# frozen_string_literal: true

RSpec.describe ProductsDatabase do
  subject(:db) { described_class.new }

  describe '#get_product_packs' do
    example do
      actual = db.get_product_packs('VS5')
      expect(actual).to contain_exactly(3, 5)
    end

    example do
      actual = db.get_product_packs('MB11')
      expect(actual).to contain_exactly(2, 5, 8)
    end

    example do
      actual = db.get_product_packs('CF')
      expect(actual).to contain_exactly(3, 5, 9)
    end
  end

  describe '#get_product_pack_cost' do
    example do
      actual = db.get_product_pack_cost('VS5', 3)
      expect(actual).to eq 6.99
    end

    example do
      actual = db.get_product_pack_cost('MB11', 8)
      expect(actual).to eq 24.95
    end

    example do
      actual = db.get_product_pack_cost('CF', 5)
      expect(actual).to eq 9.95
    end
  end
end
