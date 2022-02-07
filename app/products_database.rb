# frozen_string_literal: true

# Abstraction layer that provides product packs/costs data.
# This particular implementation reads data from products.csv file.
class ProductsDatabase
  DB_FILE = 'products.csv'

  # Finds a product by code and returns its list of packs
  def get_product_packs(product_code)
    find_product(product_code).keys
  end

  # Finds a pack by product code and pack size and returns its cost
  def get_product_pack_cost(product_code, pack)
    find_product(product_code)[pack]
  end

  private

  def find_product(product_code)
    @data ||= read_db
    @data.fetch(product_code)
  end

  def read_db
    data = {}

    CSV.foreach(DB_FILE, headers: true) do |row|
      code = row['Code']

      data[code] ||= {}
      data[code][row['Pack'].to_i] = row['Cost'].to_f
    end

    data
  end
end
