class DiscountCalculator
  def self.do_it_for(good_price, quantity)
    new(good_price, quantity).calc
  end

  def initialize(good_price, quantity)
    @good_price, @quantity = good_price, quantity
  end

  def calc
    value_with_discount = (specially_priced_quantity / quantity_to_special_price) * special_price
    value_without_discount = (@quantity - specially_priced_quantity) * regular_price
    value_with_discount + value_without_discount
  end

  private

  def specially_priced_quantity
    @quantity - (@quantity % quantity_to_special_price)
  end

  def quantity_to_special_price
    @good_price[:special_price][0]
  end

  def special_price
    @good_price[:special_price][1]
  end

  def regular_price
    @good_price[:regular_price]
  end
end