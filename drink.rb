#自販機商品（飲み物）クラス
class Drink
  # 商品種別定義
  module Kind
    NONE=0
    COLA=1
    REDBULL=2
    WATER=3
  end

  #以下は隠蔽
  ITEMS_MASTER={
    Kind::COLA => {name: "cola", price: 120},
    Kind::REDBULL => {name: "redbull", price: 200},
    Kind::WATER => {name: "water", price: 100}
  }.freeze
  private_constant :ITEMS_MASTER

  # インスタンス生成, 初期化
  # 使用例1
  # v = Drink.new(0, "potato", 50)
  # 使用例2
  # v = Drink.new(1)
  def initialize(kind, name='', price=0)
    @kind = kind
    if[*1..3].include?(kind)
      @name = ITEMS_MASTER[kind][:name]
      @price = ITEMS_MASTER[kind][:price]
    else
      @name = name
      @price = price
    end
  end

  #以下はインスタンスメソッド定義
  # 使用例
  # d = Drink.new(1); d.kind
  def kind
    @kind
  end

  def name
    @name
  end

  def price
    @price
  end

  #以下はクラスメソッド定義
  # 使用例
  # price = Drink::price(1)
  def self.price (kind)
    if ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:price]
    else
      0
    end
  end

  def self.name (kind)
    if ITEMS_MASTER.has_key?(kind)
      ITEMS_MASTER[kind][:name]
    else
      nil
    end
  end
end
