---
title: "この雛型の使い方"
author: "suzusime"
documentclass: "yayabook"
papersize: b5
classoption: ["pandoc", "magstyle=nomag*", "jafont=ipaex"]
---

# はじめに
## これは何？
yayabookは「Markdownで書かれた文書をPandocでLaTeX形式に変換し、LuaLaTeXによる処理でPDFを得る」という方法で組版を行うための雛型です。

## 入力に用いるMarkdownの形式
基本的にはPandocによる拡張Markdownを用いますが、以下のオプションを加えています。

`+ignore_line_breaks`
:    改行を半角スペースに変換しません。


## ドキュメントクラス
ドキュメントクラスにはbxjsbook.clsをもとにした（といっても現状はなにも変更していませんが）yayabook.clsを用います。

# 使用方法
## 依存
- TexLive
    - 動作確認はTeXLive 2018で行っています。必ずしも2018である必要はありませんが、LuaLaTeX(-ja)を利用するためある程度新しい必要があります。
    - フルインストールである必要はありませんが、LuaLaTeXの日本語環境やLatexmkが必要なことに注意してください。
- Make
- Pandoc

## 導入
```bash
$ git clone https://github.com/suzusime/yayabook.git && cd yayabook
$ make  #このサンプル文書をビルドします
```

入力するファイルを`README.md`から変更したい場合は、`Makefile`を開いて`filename`変数を変更してください。

# 原稿の書き方
## YAMLヘッダ
原稿の題、著者名、およびドキュメントクラスに渡す書式に関する諸情報は、pandoc拡張MarkdownのYAMLヘッダによって定義します。

たとえばこの文書の場合は次のようになります。

```yaml
---
title: "この雛型の使い方"
author: "suzusime"
documentclass: "yayabook"
papersize: b5
classoption: ["pandoc", "magstyle=nomag*", "jafont=ipaex"]
---
```

紙の大きさは`a4`、`b5`のように指定します。
`a4paper`や`b5j`のようなものでないことに注意してください。
なお、B系列はJISのものになります。

`=`がある場合などは引用符でくくらないとパースに失敗するようなので注意してください。

## 見出しのラベル
見出しにつくラベル（参照に用いる）は自動的に生成されますが、日本語の場合Unicodeコードポイントを数字で表したものに変換されてしまいます。
これが困る場合は見出しの後に`{}`で括った*`#`から始まる*ラベルを書くことで手動で指定できます。

```markdown
## 導入 {#install}
```

これを参照するためには、

```markdown
[導入](#install)
```

のように書きます。
実際にこれを試すと[導入](#install)のようになります（色がつかずリンクとわかりづらいですが、確かにリンクになっています）。

上では

> 見出しにつくラベル（参照に用いる）は自動的に生成されますが、
  日本語の場合Unicodeコードポイントを数字で表したものに変換されてしまいます。
  これが困る場合は

と書きましたが、実際はこれで困ることはなさそうです。

というのも、参照する側も同じく（TeX処理系での問題がない）ASCII表現になるからで、単に

```markdown
[導入]
```

と書けば、[導入]とリンクになります。
