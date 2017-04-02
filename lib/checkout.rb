require_relative './discount_calculator'

class Checkout
  attr_reader :items

  def initialize(prices)
    @prices = prices
    @items, @items_value = Hash.new, Hash.new
  end

  def scan(good)
    @items[good.to_sym] = 0 if @items[good.to_sym].nil?
    @items[good.to_sym] += 1
  end

  def total
    calc_items_price
    @items_value.map{ |_item, value| value }.reduce(:+) or 0
  end

  private

  def calc_items_price
    @items_value = Hash.new
    @items.each do |item, quantity|
      @items_value[item] = (special_price_for?(item, quantity)) ?
          DiscountCalculator.do_it_for(@prices[item], quantity) :
          quantity * @prices[item][:regular_price]
    end
  end

  def special_price_for?(good, quantity)
    return false if @prices[good][:special_price].nil?
    quantity >= @prices[good][:special_price].first # Should it be extracted to another method to be clearest?
  end
end
