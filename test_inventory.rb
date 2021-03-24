require 'minitest/autorun'
require './inventory.rb'

class InventoryTest < Minitest::Test
  #共通処理0
  def test_init_0
    @inv = Inventory.new
    @cola = Drink.new(Drink::Kind::COLA)
  end

  #共通処理1
  def test_init
    @inv = Inventory.new
    @cola = Drink.new(Drink::Kind::COLA)
    @inv.add(@cola, 10)
  end

  #共通処理2
  def test_init2
    @inv = Inventory.new
    @cola = Drink.new(Drink::Kind::COLA)
    @redbull = Drink.new(Drink::Kind::REDBULL)
    @water = Drink.new(Drink::Kind::WATER)

    @inv.add(@cola, 5)
    @inv.add(@redbull, 8)
    @inv.add(@water, 20)
  end


  #在庫の追加(正常系)
  def test_add_normally
    test_init_0

    assert_equal 5, @inv.add(@cola, 5)
    assert_equal 10, @inv.add(@cola, 5)
  end

  #在庫の追加(異常系)
  def test_add_abnormally
    test_init_0

    assert_nil @inv.add(@cola, 0.5) #本数が少数
    assert_nil @inv.add(@cola, -5.5) #本数が負の値
    assert_nil @inv.add("sports", 100) #Drinkクラスのインスタンスでないものを追加）
  end

  #売上情報の取得
  def test_get_inventory
    test_init

    assert_equal ({1=>10}), @inv.get_inventory
  end

  #在庫の払い出し(正常系)
  def test_pull_normally
    test_init

    #在庫の払い出し（1:cola＠120円）と売り上げ確認
    assert_equal 4, @inv.pull(Drink::Kind::COLA, 4)
    assert_equal ([{1=>4}, 480]), @inv.current_sales

    assert_equal 6, @inv.pull(Drink::Kind::COLA, 6)
    assert_equal ([{1=>10}, 1200]), @inv.current_sales

    assert_equal 0, @inv.pull(Drink::Kind::COLA, 1)
    assert_equal ([{1=>10}, 1200]), @inv.current_sales
  end

  #在庫の払い出し(異常系)
  def test_pull_abnormally
    test_init

    assert_nil @inv.pull(0.1, 1) #種別が少数
    assert_nil @inv.pull(-1, 1) #種別が負の値
    assert_nil @inv.pull(Drink::Kind::COLA, -1) #本数が負の値
  end

  #現在の売上金額を返す(正常系)
  def test_current_sales_normally
    test_init
    @inv.pull(@cola, 10)

    assert_equal ([{1=>10}, 1200]), @inv.current_sales
  end

  #現在の売上金額を返す(異常系)
  def test_current_sales_normally
    test_init
    @inv.pull(@cola, 11) #在庫以上の本数

    assert_equal ([{1=>0}, 0]), @inv.current_sales
  end

  #在庫の払い出し（１つ）正常系
  def test_pull_one_normally
    test_init

    assert_equal 1, @inv.pull_one(Drink::Kind::COLA)
  end

  #在庫の払い出し（１つ）異常系
  def test_pull_one_abnormally
    test_init

    assert_equal 0, @inv.pull_one(Drink::Kind::WATER) #在庫切れの商品（water）
    assert_equal 0, @inv.pull_one(4) #種別に設定されていない商品
    assert_nil @inv.pull_one(0.5) #種別が少数
    assert_nil @inv.pull_one("kajiyama") #種別が文字列
  end

  #売り上げの回収
  def test_reset_sales
    test_init
    @inv.pull(Drink::Kind::COLA, 10)

    #売上回収したら売上情報がリセットされていることの確認
    assert_equal ([{1=>10}, 1200]), @inv.reset_sales
    assert_equal ([{1=>0}, 0]), @inv.current_sales
  end

  #購入可能か調査（正常系）
  def test_can_buy_normally
    test_init2

    #投入金額分以上の在庫があることの確認[買える本数, おつり]
    assert_equal [4, 20], @inv.can_buy?(Drink::Kind::COLA, 500)
    assert_equal [3, 150], @inv.can_buy?(Drink::Kind::REDBULL, 750)
    assert_equal [10, 0], @inv.can_buy?(Drink::Kind::WATER, 1000)

    assert_equal [5, 9400], @inv.can_buy?(Drink::Kind::COLA, 10000)
    assert_equal [8, 8400], @inv.can_buy?(Drink::Kind::REDBULL, 10000)
    assert_equal [20, 8000], @inv.can_buy?(Drink::Kind::WATER, 10000)
  end

  #購入可能か調査（異常系）
  def test_can_buy_abnormally
    test_init2

    assert_nil @inv.can_buy?(0.1, 200) #種別が少数
    assert_nil @inv.can_buy?(-1, 200)  #種別が負の数
    assert_equal 0, @inv.can_buy?(Drink::Kind::COLA, 10) #在庫が足りない
  end

  #投入金額と在庫の点から購入可能な種別を配列で返却（正常系）
  def test_available_items_normally
    test_init2

    assert_equal [1, 2, 3], @inv.available_items(600)
    assert_equal [3], @inv.available_items(100)
    assert_equal [], @inv.available_items(99)
    assert_equal [], @inv.available_items(0)
  end

  #投入金額と在庫の点から購入可能な種別を配列で返却（異常系）
  def test_available_items_abnormally
    test_init2

    assert_nil @inv.available_items(0.5) #種別が少数
    assert_nil @inv.available_items(-200) #種別が負の数
    assert_nil @inv.available_items(150.05)
    assert_nil @inv.available_items("") #引数の金額が文字列
  end

end
