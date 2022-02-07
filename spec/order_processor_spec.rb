# frozen_string_literal: true

RSpec.describe OrderProcessor do
  subject(:processor) { described_class.new(calculator, db) }

  let(:calculator) { instance_spy(PacksCalculator, divide_into_packs: { 5 => 2 }) }
  let(:db) { instance_spy(ProductsDatabase, get_product_packs: [3, 5], get_product_pack_cost: 1) }

  it 'calls ProductsDatabase for list of available product packs' do
    processor.process('10 VS5')
    expect(db).to have_received(:get_product_packs).with('VS5')
  end

  it 'calls PacksCalculator to divide product quantity into packs' do
    processor.process('10 VS5')
    expect(calculator).to have_received(:divide_into_packs).with(10, [3, 5])
  end

  it 'prints order total and package breakdown' do
    expect { processor.process('10 VS5') }.to \
      output("10 VS5 $2.0\n\t2 x 5 $1\n").to_stdout
  end

  it 'prints an error message when order could not be divided into packs' do
    allow(calculator).to receive(:divide_into_packs).and_return(nil)

    expect { processor.process('11 VS5') }.to \
      output("11 VS5 - couldn't process\n").to_stdout
  end
end
