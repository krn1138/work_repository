require 'minitest/autorun'
require './jihanki.rb'
require './drink.rb'
require './inventory.rb'

class VendingMachineTest < Minitest::Test
  def test_slot_money
    vm = VendingMachine.new
    # 受付可能なお金を１つずつ投入できること
    assert_equal 10, vm.slot_money(10)
    vm.return_money
    assert_equal 50, vm.slot_money(50)
    vm.return_money
    assert_equal 100, vm.slot_money(100)
    vm.return_money
    assert_equal 500, vm.slot_money(500)
    vm.return_money
    assert_equal 1000, vm.slot_money(1000)
    vm.return_money
    assert_nil vm.slot_money(1)
    assert_nil vm.slot_money("kaziyama")
    #お金を投入したら購入可能商品と現在の投入金額が表示されること
    assert_output("現在の投入金額は500円です。\n購入可能商品一覧\n1:cola\n",nil) do
    vm.slot_money(500)
    end
  end

    # 投入したお金を払い戻しできること
  def test_return_money
    vm1 = VendingMachine.new
    vm1.slot_money(500)
    assert_output("500円のお返しです！\n",nil) do #戻り値は0なのでoutputで作りました
    vm1.return_money
    end
  end

    # 初期化された状態で投入金額は０円であること
    # 投入金額の総計を確認できること
  def test_current_slot_money
    vm2 = VendingMachine.new
    assert_equal 0, vm2.current_slot_money
    vm2.slot_money(500)
    assert_equal 500, vm2.current_slot_money
  end

    # ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やすこと
    # ＋投入金額の総計と購入可能商品が表示されること
    # 投入金額、在庫の点で、コーラが購入できるかどうかを取得できること
  def test_purchase
    vm3 = VendingMachine.new
    vm3.slot_money(500)
    assert_output("colaを1本購入しました！\n現在の投入金額は380円です。\n購入可能商品一覧\n1:cola\n",nil) do
    vm3.purchase(Drink::Kind::COLA)
    end
    assert vm3.purchase(Drink::Kind::COLA) #買えるパターン
    refute vm3.purchase(Drink::Kind::REDBULL) #在庫がないパターン
    vm3.return_money
    refute vm3.purchase(Drink::Kind::COLA) #投入金額が足りないパターン
  end

    # 現在の売り上げ金額を取得できること
  def test_total_sales
    vm4 = VendingMachine.new
    vm4.slot_money(500)
    vm4.purchase(Drink::Kind::COLA)
    assert_output("商品名:cola,価格:120,販売本数:1\n現在の売上金額: 120円\n",nil) do
    vm4.total_sales
    end
  end

  # 初期化された状態でコーラが５本格納されていること
  # 格納されているジュースの情報（値段と名前と在庫）を取得できること
  def test_stock_drink
    vm5 = VendingMachine.new
    assert_output("商品名:cola,価格:120,在庫数:5\n",nil) do
      vm5.stock_drink
    end
  end
end
