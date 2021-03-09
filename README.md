# Drinkクラス説明 #

## 1.概要 ##

  * VendingMachineで販売する飲み物クラス

## 2.機能概要 ##

### 2.1 取り扱う飲み物の**価格表**（種別/名称/価格）を管理（クラスメソッド） ###

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
        指定された種別の名称/価格を更新, ☆更新対象をキーワード引数で指定する
        （使用例）Drink::update(Drink::Kind::COLA, name: "coke")
        
  * Drink::destroy(kind)
        指定された種別の名称/価格を更新
```


### 2.2 個々の飲み物情報を管理（インスタンスメソッド） ###

公開
```
  * initialize(kind, name='', price='')  
        - 指定された種別の飲み物を指定された名称、価格で初期化
    　  - 価格表に登録済の種別は、名称/価格不要でインスタンス化される
        （使用例1）cola = Drink::new(Drink::Kind::COLA)
        （使用例2) milk = Drink::new(10, "milk", 150)
    　  - ☆登録されていない種別を指定すると例外クラスを返却し, インスタンスは生成されない

  * kind
        種別を返却

  * name
        名前を返却

  * price
        価格を返却
```

# Inventoryクラス説明 #
## 1.概要 ##

  * VendingMachineの在庫クラス

## 2.機能概要 ##

  * 取り扱う飲み物の在庫（種別/本数）を管理

  * 取り扱う飲み物の売上（種別/本数/売上金額）を管理

## 3.機能概要 ##

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

  * to_s
        在庫情報を文字列で返す

  * reset_sales
        売り上げの回収

  * available_items(input_money)
        引数で渡された投入金額と在庫の点から購入可能な種別を配列で返却
```

private
```
  * can_buy?(kind, input_money)        
        引数で与えられた金額で, 引数で与えられた名前の飲み物が購入できるかどうかを取得
　      購入できる場合は購入可能本数とお釣りを配列で返却, 購入できない場合は0を返却
        (例1）投入金額800円, コーラの金額120円, 在庫数12本 => 戻り値 (6, 80)
        (例2）投入金額800円, コーラの金額120円, 在庫数4本 => 戻り値 (4, 320)
  

```
