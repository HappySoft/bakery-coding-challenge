# frozen_string_literal: true

# Responsible for parsing incoming order, divide it into packs and report breakdown and total cost.
class OrderProcessor
  ORDER_PATTERN = /\A(?<quantity>\d+)\s+(?<product_code>\w+)\z/

  # @param calculator [PacksCalculator]
  # @param products_db [ProductsDatabase]
  def initialize(calculator = PacksCalculator.new, products_db = ProductsDatabase.new)
    @calculator  = calculator
    @products_db = products_db
  end

  # @param order [String] product quantity and code
  def process(order)
    quantity, product_code = parse_order_line(order)
    return unless product_code

    product_packs = @products_db.get_product_packs(product_code)
    order_packs   = @calculator.divide_into_packs(quantity, product_packs)

    if order_packs
      puts "#{order} $#{calculate_order_cost(product_code, order_packs)}"
      print format_order_breakdown(product_code, order_packs)
    else
      puts "#{order} - couldn't process"
    end
  end

  private

  def calculate_order_cost(product_code, packs)
    result = 0.0

    packs.each do |pack, number_of_packs|
      pack_cost = @products_db.get_product_pack_cost(product_code, pack)
      result += number_of_packs * pack_cost
    end

    result.round(2)
  end

  def format_order_breakdown(product_code, packs)
    result = +''

    packs.each do |pack, number_of_packs|
      pack_cost = @products_db.get_product_pack_cost(product_code, pack)
      result << "\t#{number_of_packs} x #{pack} $#{pack_cost}\n"
    end

    result
  end

  def parse_order_line(line)
    matches = ORDER_PATTERN.match(line)
    return unless matches

    [matches[:quantity].to_i, matches[:product_code]]
  end
end
