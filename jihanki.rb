#require './jihanki.rb'
#vm = VendingMachine.new
#load './jihanki.rb'

require './drink.rb'
require './inventory.rb'

class VendingMachine
  # ステップ０  お金の投入と払い戻しの例コード
  # ステップ１扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    # 初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。
    # @stock = {cola:5}
    # ジュースを3種類管理できるようにする。
    @stock=Inventory.new
    @stock.add( Drink.new(Drink::Kind::COLA), 5 )
  end
  def stock
    @stock
  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。
  def slot_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    puts "#{money}"  unless MONEY.include?(money)
    # 自動販売機にお金を入れる
    @slot_money += money
    #投入金額、在庫の点で購入可能なドリンクのリストを取得できる。
    puts @stock.available_items(current_slot_money)
    @slot_money
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  #格納されているジュースの情報（値段と名前と在庫）を取得できる。
  def stock_drink
    @stock.to_s
  end

  #投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。
  def can_buy?(item)
    a = @stock.can_buy?(item , current_slot_money)
    if(a.class==Array)
      true
    else
      false
    end
  end

  #現在の売上金額を取得できる。
  def total_sales
    @stock.current_sales
  end

  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。
  def purchase(item)
    if can_buy?(item)
      @slot_money -= Drink::price(item)
      return (@stock.pull_one(item)>0 ? true : false)
    else
      false
    end
  end

  #def return_moneyと同意味
  #払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。
  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、釣り銭（投入金額とジュース値段の差分）を出力する。
#   def refund(item)
#     purchase(item) ? @slot_money : false
#   end
end
