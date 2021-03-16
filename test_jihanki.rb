require 'minitest/autorun'
require './jihanki.rb'
require './drink.rb'
require './inventory.rb'

class VendingMachineTest < Minitest::Test
  def test_vendeingmachine
    vm = VendingMachine.new
    @slot_money = 0
    @stock=Inventory.new
    @stock.add( Drink.new(Drink::Kind::COLA), 5 )

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

    # assert_output("",vm.slot_money(2000))
    #お金を投入したら購入可能商品と現在の投入金額が表示されること
    vm.return_money
    assert_output("現在の投入金額は500円です。\n購入可能商品:\n1:cola\n",nil) do
       vm.slot_money(500)
    end

	  # 投入したお金を払い戻しできること
    vm.return_money
    vm.slot_money(500)
    assert_equal 500, vm.current_slot_money

    # 初期化された状態で投入金額は０円であること
    vm1 = VendingMachine.new
    assert_equal 0, vm1.current_slot_money

    # 初期化された状態でコーラが５本格納されていること
    assert vm1.stock.hash_num[Drink::Kind::COLA]
    assert_operator 5, :<=,vm1.stock.hash_num[Drink::Kind::COLA]

    # 投入金額の総計を確認できること
    vm1.return_money
    vm1.slot_money(500)
    assert_equal 500, vm1.current_slot_money

	  # ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やすこと
	  # ＋投入金額の総計と購入可能商品が表示されること
    assert vm1.purchase(Drink::Kind::COLA)
    refute vm1.purchase(Drink::Kind::REDBULL) #在庫がない場合
    vm1.return_money
    refute vm1.purchase(Drink::Kind::COLA) #投入金額が足りない場合

    vm2 = VendingMachine.new
    vm2.slot_money(500)
    assert_output("現在の投入金額は380円です。\n購入可能商品:\n1:cola\n",nil) do
       vm2.purchase(Drink::Kind::COLA)
    end

  	# 格納されているジュースの情報（値段と名前と在庫）を取得できること
    assert_equal "商品名:cola,価格:120,在庫数:4\n", vm2.stock_drink

  	# 投入金額、在庫の点で、コーラが購入できるかどうかを取得できること
    assert vm2.can_buy?(Drink::Kind::COLA)
    refute vm2.can_buy?(Drink::Kind::REDBULL) #在庫がない場合
    vm2.return_money
    refute vm2.can_buy?(Drink::Kind::COLA) #投入金額が足りない場合

	  # 現在の売り上げ金額を取得できること
    vm3 = VendingMachine.new
    vm3.slot_money(500)
    vm3.purchase(Drink::Kind::COLA)
    assert_equal 120, vm3.total_sales
  end
end
