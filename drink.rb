# 自販機商品（飲み物）クラス
class Drink
  # 商品種別定義
  module Kind
    NONE=0
    COLA=1
    REDBULL=2
    WATER=3
  end

  # 価格表（隠蔽）
  ITEMS_MASTER={
    Kind::COLA => {name: "cola", price: 120},
    Kind::REDBULL => {name: "redbull", price: 200},
    Kind::WATER => {name: "water", price: 100}
  }
  private_constant :ITEMS_MASTER

  # インスタンス生成, 初期化
  # 使用例1, 価格表に登録済みの飲み物は種別指定のみでOK
  #   v = Drink.new(Kind::COLA)
  # 使用例2
  #   v = Drink.new(4, "milk", 200)
  # 注意, 指定された種別が数値で無い場合は例外をスローする
  #   v = Drink.new("cola") --> DrinkInitializ
  def initialize(kind, name='', price=0)
    if(kind.class!=Integer)
      raise DrinkInitializeError, "種別は正の整数値を指定してください. #{kind}.to_s"
    else
      @kind = kind
      if ITEMS_MASTER.keys.include?(kind)
        @name = ITEMS_MASTER[kind][:name]
        @price = ITEMS_MASTER[kind][:price]
      else
        @name = name
        @price = price
      end
    end
  end

  # 以下はインスタンスメソッド定義

  # 種別を返す
  def kind
    @kind
  end

  # 名前を返す
  def name
    @name
  end

  # 価格を返す
  def price
    @price
  end

  # 以下はクラスメソッド定義
  # 価格表に、指定した飲み物が登録されているか取得
  # 使用例
  # judge = Drink::present?(100)
  def self.present? (kind)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    else
      ITEMS_MASTER.has_key?(kind)
    end
  end

  # 価格表から、指定した飲み物の価格を取得
  # 使用例
  # price = Drink::price(Kind::COLA)
  def self.price (kind)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:price]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  # 価格表から、指定した飲み物の名前を取得
  # 使用例
  # name =  Drink::name(Kind::COLA)
  def self.name (kind)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:name]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  # 価格表に、指定した飲み物の名前/価格を追加
  # 使用例
  # result =  Drink::insert(4, "milk", 200)
  def self.insert(kind, name, price)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      puts "specified kind is already exists."  #return nil
    else
      ITEMS_MASTER[kind]={name: name, price: price}
    end
  end

  # 価格表の、指定した飲み物の名前/価格を更新
  # 使用例
  # result =  Drink::update(Kind::COLA, "coke", 150)
  def self.update(kind, name: name="Unspecified", price: price=-1)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    elsif ITEMS_MASTER.has_key?(kind)
      if ( (name != "Unspecified")  && !name.empty? )
        ITEMS_MASTER[kind][:name]=name
      end
      if (price >= 0)
        ITEMS_MASTER[kind][:price]=price
      end
      ITEMS_MASTER[kind]
    else
      puts "specified kind is not exists."  #return nil
    end
  end

  # 価格表の、指定した飲み物の名前/価格を削除
  # 使用例
  # result = Drink::destroy(Kind::COLA)
  def self.destroy(kind)
    if( !(kind.class==Integer && kind>=0) )
      puts '種別は正の整数値を指定してください'   #return nil
    else
      ITEMS_MASTER.delete(kind)  #return nil if kind is NOT exists
    end
  end

  # 価格表の内容を文字列で出力
  # 使用例
  # result = Drink::master
  def self.master
    ITEMS_MASTER.each do |kind, item|
      puts "種別:#{kind.to_s}, 名前:#{item[:name]}, 価格:#{item[:price]}\n"
    end
    # return ITEMS_MASTER
  end
end

# 例外クラス定義
class DrinkInitializeError < StandardError
end
