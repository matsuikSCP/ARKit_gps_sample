# ARKit_gps_sample
ARKitで特定の地点にオブジェクトを配置するアプリケーション

## プロジェクトの開き方

xcodeの既存プロジェクトを開く -> ARKit_GPS_Sample.xcodeproj を選択
[apple idの登録と署名](https://www.radical-dreamer.com/programming/xcode-run-on-device/)が必要です

## 各swiftファイルについて

- AppDelegate.swift
  - 起動時に最初に走る(@mainで指定している)
  - ここでContentViewを指定している
- ContentView
  - 画面表示を管理
  - 最初にmakeUIViewが走る。
  - プロパティに変化があるとupdateUIViewが走る
  - 44,45行目の緯度経度を変えると、任意の座標にオブジェクトを配置できる
- LocationViewModel
  - モデルの定義
  - 位置情報(緯度・経度)と方角(0~360)をプロパティとして持つ


