require 'minitest/autorun'
require './drink.rb'
require 'byebug'

class DrinkTest < Minitest::Test
  def test_class_method_master
    #価格表一覧を参照
    master = {1=>{:name=>"cola", :price=>120}, 2=>{:name=>"redbull", :price=>200}, 3=>{:name=>"water", :price=>100}}
    assert_equal master, Drink::master
  end

  def test_class_method_price
    #種類１の価格が正しく表示される
    assert_equal 120, Drink::price(Drink::Kind::COLA)
    #正しくない種別が指定された時にドリンク名がnilがかえることを確認
    assert_nil Drink::price(-1)
    assert_nil Drink::price("1")
    assert_nil Drink::price(0.5)
    assert_nil Drink::price(100)
  end

  def test_class_method_name
    #種類３のドリンク名が正しく表示される
    assert_equal "water", Drink::name(Drink::Kind::WATER)
    #正しくない種別が指定された時にドリンク名がnilがかえることを確認
    assert_nil Drink::name(-1)
    assert_nil Drink::name("1")
    assert_nil Drink::name(0.5)
    assert_nil Drink::name(100)
  end

  def test_class_method_present?
    #指定された登録済み種別の価格表登録有無を返却
    assert_equal true, Drink::present?(Drink::Kind::COLA)
    #正しくない種別が指定された時にドリンク名がnilがかえることを確認
    assert_nil Drink::present?(-1)
    assert_nil Drink::present?("1")
    assert_nil Drink::present?(0.5)
    #正しくない種別が指定された時にドリンク名がfalseがかえることを確認
    refute Drink::present?(100)
  end

  #更新系
  def test_class_method_insert
    #あたらしい種類のアイテムの種類/名前/価格を追加できること
    #milkを追加
    drink = {name: "milk", price: 150}
    assert_equal drink, Drink::insert(10, "milk", 150)
    #異常形
    #種類に文字列が入る
    assert_nil Drink::insert("milk", "milk", 150)
    #すでにある種類にmilkがはいる
    assert_nil Drink::insert(1, "milk", 150)
  end

  def test_class_method_update
    #価格表の既存のアイテムの種類/名前/価格を変更できること
    drink = {name: "coke", price: 150}
    assert_equal drink, Drink::update(1, name: "coke", price: 150)
    assert_equal drink, Drink::update(1, name: "coke")
    assert_equal drink, Drink::update(1, price: 150)
    #異常形
    #種類に文字列がはいる
    assert_nil Drink::update("5", name: "coke", price: 150)
    #種類に異常な文字が入る
    assert_nil Drink::update(-1, name: "coke", price: 150)
  end

  def test_class_method_destroy
    assert_output("種別:1, 名前:cola, 価格:120\n種別:2, 名前:redbull, 価格:200\n種別:3, 名前:water, 価格:100\n",nil) do
      Drink::master
    end
    h = {name: "cola", price: 120}
    assert_equal h, Drink::destroy(Drink::Kind::COLA)
    assert_output("種別:2, 名前:redbull, 価格:200\n種別:3, 名前:water, 価格:100\n",nil) do
      Drink::master
    end
  end

  def test_initialize
    #価格表に登録済みアイテムを作成
    #アイテムの種類/名前/価格を参照
    cola = Drink.new(Drink::Kind::COLA)
    assert_equal cola.kind, 1
    assert_equal cola.name, "cola"
    assert_equal cola.price, 120
  end

  def test_initialize_abnormal
    # bad_object1 = Drink.new(-1)
    # bad_object2 = Drink.new("1")
    # bad_object3 = Drink.new(0.5)
    exp = assert_raises(DrinkInitializeError) do
      bad_object1 = Drink.new(-1)
      bad_object2 = Drink.new("1")
      bad_object3 = Drink.new(0.5)
    end
    assert_kind_of DrinkInitializeError, exp
  end

  def test_initialize_unregistered
    #価格表に未登録のアイテムを作成
    #orangeの場合
    orange = Drink.new(10, "", 0)
    assert_equal orange.kind, 10
    assert_equal orange.name, ""
    assert_equal orange.price, 0
  end

  def test_kind
    cola = Drink.new(Drink::Kind::COLA)
    assert_equal cola.kind, Drink::Kind::COLA
  end

  def test_name
    cola = Drink.new(Drink::Kind::COLA)
    assert_equal cola.name, Drink::name(Drink::Kind::COLA)
  end

  def test_price
    cola = Drink.new(Drink::Kind::COLA)
    assert_equal cola.price, Drink::price(Drink::Kind::COLA)
  end
end
