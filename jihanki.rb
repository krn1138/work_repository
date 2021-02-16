class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @total_sales = 0
    # 初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。
    # @stock = {cola:5}
    # ジュースを3種類管理できるようにする。
    @stock = { cola: 5, redbull: 5, water: 5 }
    @price = { cola: 120, redbull: 200, water: 100 }
  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return false unless MONEY.include?(money)
    # 自動販売機にお金を入れる
    @slot_money += money
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
    return "在庫数#{@stock}", "価格#{@price}"
  end

  #投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。
  def check_buy_cola
    if @slot_money >= (@price[:cola]) && (@stock[:cola]) != 0
      return "販売中"

    elsif @slot_money < (@price[:cola]) && (@stock[:cola]) != 0
      return "お金が足りません"

    else
      return  "売り切れ"
    end
  end

  #現在の売上金額を取得できる。
  def total_sales
    @total_sales
  end
  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす。
# :必須↓(:cola)
  def buy(item)
    if @slot_money >= @price[item]
      @slot_money -=  @price[item]
      @stock[item] -=1
      @total_sales+=  @price[item]
      return "#{item}を購入しました"
    else
      #投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。
      return false
    end
  end

  #払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。
  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、釣り銭（投入金額とジュース値段の差分）を出力する。
  def refund(item)
    if @slot_money >= @price[item]
      @slot_money -=  @price[item]
      @stock[item] -=1
      @total_sales+=  @price[item]
      return "#{@slot_money}円"
    else
      return false
    end
  end

 #投入金額、在庫の点で購入可能なドリンクのリストを取得できる。
  def item_list
    list = []
    @stock.each do |drink, stocks|
     if @slot_money >= (@price[drink]) &&  ([stocks]) !=0
        list << drink
      end
    end
    return list
  end
end
