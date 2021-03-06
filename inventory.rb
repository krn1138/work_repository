require './drink.rb'

#在庫/売上管理クラス
class Inventory
  attr_reader :hash_num
  attr_reader :sales_volume

  #エラーメッセージ
  MsgErrInvalidObject = '取り扱い対象外です.'
  MsgErrUnRegisterdKind = '指定された飲み物は未登録です.'
  MsgErrInvalidNumber = '個数は正の整数値を指定してください.'
  MsgErrInvalidMoney = '金額は正の整数値を指定してください.'
  MsgErrInvalidKind = '種別は正の整数値を指定してください.'
  MsgErrOutOfStocks = '指定された種別の在庫がありません.'

  #初期化
  def initialize
    @hash_num = {}    # {1:  50, 2:  50, 3:  50}  商品種別をキーとするハッシュ
    @sales_volume = {}
    @sales = 0
  end

  #在庫の追加
  def add(drink_obj, num)
    if( drink_obj.class != Drink )
      puts MsgErrInvalidObject #return nil
    elsif !(Drink::present?(drink_obj.kind))
      puts MsgErrUnRegisterdKind #return nil
    elsif( !(num.class == Integer && num>0) )
      puts MsgErrInvalidNumber #return nil
    elsif( @hash_num.has_key? (drink_obj.kind) )
      @hash_num[drink_obj.kind] += num
    else
      @sales_volume[drink_obj.kind] = 0
      @hash_num[drink_obj.kind] = num
    end
  end

  #在庫の払い出し
  def pull(kind, num)
    if( !(kind.class == Integer && kind >= 0) ) #種別が正の整数でなければnilを返却
      puts MsgErrInvalidKind #return nil
    elsif( !(num.class == Integer && num >= 0) )
      puts MsgErrInvalidNumber #return nil
    elsif( !@hash_num.has_key?(kind) )
      puts MsgErrOutOfStocks
      return 0
    else
      pull_num = (@hash_num[kind] < num) ? @hash_num[kind] : num
      @hash_num[kind] -= pull_num
      @sales_volume[kind] += pull_num
      @sales += ( pull_num * Drink::price(kind) )  #払い出した分の売り上げをカウント
      return pull_num
    end
  end

  #在庫の払い出し（１つ）
  def pull_one(kind)
    pull(kind, 1)
  end

  def get_inventory
    @hash_num
  end

  #現在の売り上げ金額を返す
  def current_sales
    [@sales_volume, @sales]
  end

  #売り上げの回収
  def reset_sales #jihankiクラスでは呼べない
    # 返却する売上情報を保存
    origin = [@sales_volume, @sales]
    ret = Marshal.dump(origin)
    copy = Marshal.load(ret)
    @sales_volume.transform_values! {|v| v * 0}
    @sales = 0
    copy
  end

=begin
  引数で与えられた金額で, 引数で与えられた名前の飲み物が購入できるかどうかを取得
  購入できる場合は購入可能本数とお釣りを配列で返却, 購入できない場合は 0を返却
(例1）投入金額800円, コーラの金額120円, 在庫数12本 => 戻り値 (6, 80)
(例2）投入金額800円, コーラの金額120円, 在庫数4本 => 戻り値 (4, 320)
=end
  def can_buy?(kind, input_money)
    if( !(kind.class == Integer && kind >= 0) ) #種別が正の整数でなければnilを返却
      puts MsgErrInvalidKind #return nil
    elsif Drink::price(kind) && input_money < Drink::price(kind) #投入金額が足りなければ0を返却
      return 0
    elsif @hash_num.has_key?(kind)
      #投入金額を購入したい物の価格で割った商と余りを配列に格納
      ret = input_money.divmod(Drink::price(kind))
      if( @hash_num[kind] > ret[0] )
        #在庫が充分多い
        return ret
      else
        #在庫が少ない
        ret = []
        otsuri = ( input_money - Drink::price(kind)*@hash_num[kind] )
        return ret.push(@hash_num[kind], otsuri)
      end
    else
      return 0
    end
  end

  #引数で渡された投入金額と在庫の点から購入可能な種別を配列で返却
  def available_items(input_money)
    if( input_money.class != Integer ) #入力された金額が正の整数でなければnilを返却
      puts MsgErrInvalidMoney          #return nil
    elsif( input_money < 0 )           #入力された金額が正の整数でなければnilを返却
      puts MsgErrInvalidMoney          #return nil
    else
      @hash_num.map do |kind, num|
        if ( Drink::price(kind) && (input_money >= Drink::price(kind)) && (num>0) )
          kind
        end
      end.compact
    end
  end
end
