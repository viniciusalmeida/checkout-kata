require 'minitest/autorun'
require 'yaml'

require_relative '../lib/checkout'

class CheckoutTest < Minitest::Test

  path_to_prices_list = File.join(File.dirname(File.expand_path(__FILE__)), '/fixtures/prices_list.yaml')
  PRICES = YAML.load_file(path_to_prices_list).freeze

  def setup
    @checkout = Checkout.new PRICES
  end

  def test_scan
    assert_equal Hash.new, @checkout.items
    @checkout.scan 'A'; assert_equal({ A: 1 }, @checkout.items)
    @checkout.scan 'B'; assert_equal({ A: 1, B: 1 }, @checkout.items)
    @checkout.scan 'B'; assert_equal({ A: 1, B: 2 }, @checkout.items)
  end

  def price_to(goods)
    self.setup
    goods.split(//).each { |item| @checkout.scan item }
    @checkout.total
  end

  def test_basic_price_totals
    assert_equal 0, price_to('')
    assert_equal 50, price_to('A')
    assert_equal 80, price_to('AB')
    assert_equal 115, price_to('CDBA')
  end

  def test_price_totals_with_discounts_with_a_single_good
    assert_equal 100, price_to('AA')
    assert_equal 130, price_to('AAA')
    assert_equal 180, price_to('AAAA')
    assert_equal 230, price_to('AAAAA')
    assert_equal 260, price_to('AAAAAA')
  end

  def test_price_totals_with_discounts_with_random_goods
    assert_equal 160, price_to('AAAB')
    assert_equal 175, price_to('AAABB')
    assert_equal 190, price_to('AAABBD')
    assert_equal 190, price_to('DABABA')
  end

  def test_incremental_scan
    assert_equal 0, @checkout.total
    @checkout.scan 'A'; assert_equal 50, @checkout.total
    @checkout.scan 'B';  assert_equal 80, @checkout.total
    @checkout.scan 'A';  assert_equal 130, @checkout.total
    @checkout.scan 'A';  assert_equal 160, @checkout.total
    @checkout.scan 'B';  assert_equal 175, @checkout.total
  end
end
