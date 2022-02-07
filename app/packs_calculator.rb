# frozen_string_literal: true

# Calculates a minimum number of packs for a product.
# Uses simple check of every possible packs combination that can cover required
# number of product items and selects a combination with minimum number of packs.
class PacksCalculator
  # @param num_of_items [Integer] number of product items
  # @param packs_list [Array] list of all available product packs
  # @return [Hash, nil] breakdown of items in form: pack => number of the packs, or nil
  def divide_into_packs(num_of_items, packs_list)
    packs_combinations_stats =
      packs_combinations(packs_list).map do |packs_combination|
        calculate_packs_combination(num_of_items, packs_combination)
      end

    packs_combinations_stats.compact.min_by { |stats| stats.values.sum }
  end

  private

  def calculate_packs_combination(num_of_items, packs_combination)
    stats = {}

    packs_combination.sort.reverse.each do |pack|
      num_of_packs, num_of_items = num_of_items.divmod(pack)
      stats[pack] = num_of_packs unless num_of_packs.zero?
    end

    stats if num_of_items.zero?
  end

  def packs_combinations(packs_list)
    (1..packs_list.size).each_with_object([]) do |n, result|
      packs_list.combination(n) { |combination| result << combination }
    end
  end
end
