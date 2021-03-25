# Drinkクラス説明 #

## 1.概要 ##

  * VendingMachineで販売する飲み物クラス

## 2.責務 ##

  * 取り扱う飲み物の`価格表`（種別/名称/価格）を一元管理
    - 参照系
    - 更新系（管理用）

  * `個々の飲み物`の種別/名称/価格を管理
    - 価格表に登録済の飲み物の生成
    - 価格表に未登録の飲み物も受け付ける
    
## 3.機能紹介 ##

### 3.1 クラスメソッド ###

公開（参照系）
```
  * Drink::Kind
        種別の別名（COLA=1, REDBULL=2, WATER=3）

  * Drink::master
        価格表を出力

  * Drink::price(kind)
        指定された種別の価格を返却

  * Drink::name(kind)
        指定された種別の名前を返却

  * Drink::present?(kind)
        指定された種別の価格表登録有無を返却
```

公開（更新系）
```
  * Drink::insert(kind, name, price)
        あたらしい飲み物を価格表に追加

  * Drink::update(kind, name: name="unspecified", price: price=-1)
        指定された種別の名称/価格を更新,  ☆更新対象をキーワード引数で指定する
        （使用例）Drink::update(Drink::Kind::COLA, *name:* "coke")

  * Drink::destroy(kind)
        指定された種別の名称/価格を更新
```


### 3.2 インスタンスメソッド ###

公開
```
  * initialize(kind, name='', price='')
        - 指定された種別の飲み物を、指定された名称/価格で初期化
	    - ☆価格表に登録済の種別は、名称/価格不要でインスタンス化される（☆デフォルト値使用）
	      （使用例）cola = Drink::new(Drink::Kind::COLA)		

            - ☆種別に正の整数以外が指定された場合、例外（DrinkInitializeError）を発生しインスタンスを生成しない
	      （使用例）no_object = Drink::new("cola")

            - ☆種別に価格表に登録されていない数値が指定された場合は、渡された種別/名前/価格でインスタンスを生成
	      （使用例) milk = Drink::new(10, "milk", 150)

  * kind
        種別を返却

  * name
        名前を返却

  * price
        価格を返却
```

# Inventoryクラス説明 #
## 1.概要 ##

  * VendingMachineの在庫/売上管理クラス

## 2.責務 ##

  * 取り扱う飲み物の`在庫`（種別/本数）を管理

  * 取り扱う飲み物の`売上`（種別/本数/売上金額）を管理

## 3.機能紹介 ##

公開

```
  * initialize
        インスタンス生成

  * add(drink_obj, num)
        在庫の追加

  * pull(kind, num)
        在庫の払い出し

  * pull_one(kind)
        在庫の払い出し（１つ）

  * get_inventory
        在庫情報（種別/本数）を返却

  * current_sales
        現在の売上げ情報（種別/本数、総額）を配列で返却

  * reset_sales
        売上げの回収
        現在の売上げ情報（種別/本数、総額）をゼロリセットし、配列で返却
	
  * available_items(input_money)
        引数で渡された投入金額ならびに現在の在庫から、購入可能な種別を判別し配列で返却

  * can_buy?(kind, input_money)
        引数で与えられた金額で, 引数で与えられた種別の飲み物が購入できるかを判定し返却
        購入できる場合は購入可能本数とお釣りを配列で返却, 購入できない場合は0を返却
        (例1）投入金額800円, コーラの金額120円, 在庫数12本 => 戻り値 (6, 80)
        (例2）投入金額800円, コーラの金額120円, 在庫数4本 => 戻り値 (4, 320)

```
# VendingMachineクラス説明 #

## 1.概要 ##

  * 飲み物・在庫クラスを基に実際に商品を販売するクラス

## 2.責務 ##

  * 取り扱う飲み物の販売に伴う`購入者とのやりとり`
    - 飲み物在庫や売上げの管理は、Drinkクラス/Inventoryクラスに問い合わせた結果を利用
  
  * 購入者が投入した`金銭を管理`

## 3.機能紹介 ##

公開
```
  * initialize
        - 自販機の投入金額を0円にする。
        - Inventoryクラスのインスタンスを生成し、初期状態で在庫にコーラ5本を格納する。（addメソッドの第2引数）
        ※この際、Drinkクラスのインスタンスを生成し、コーラという名前の、120円の商品を格納することを定義している。（addメソッドの第1引数）

  * slot_money(money)
        金銭の投入処理。
        扱えないお金が投入された場合、そのまま出力。

  * return_money
        払い戻し操作
        投入金額を釣り銭として返す。
        自販機の投入金額を0円にする。

  * purchase(item)
        在庫クラスに投入金額と対象商品（item）を渡して購入可否を問い合わせ、OKならば購入処理（利用者へのメッセージ表示）を行う。
        ジュースの価格以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売上金額を増やす。（処理は在庫クラスに委譲）

  * current_slot_money
        現在の投入金額を返却

  * stock_drink
        格納されている飲み物の情報を返却（処理は在庫クラスに委譲）

  * add_stock
        在庫を追加する（処理は在庫クラスに委譲）

  * get_sales
        売上げ金を回収する（処理は在庫クラスに委譲）

  * total_sales
        現在の売上金額を返却（処理は在庫クラスに委譲）
```

private
```
  * can_buy?(item)
        投入金額、在庫の点で商品(item)が購入できるかどうかを取得（在庫クラスに問い合わせる）


  * lamp(items)
        引数で渡された購入可能商品（配列）をもとに購入者に分かりやすいようメッセージ作成/表示
        さらに、投入金額を明示することで、購入者がその次の処理を選択しやすいようにする（お金の追加投入or商品の購入or払い戻しなど）
```

