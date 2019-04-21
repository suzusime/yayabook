---
title: "この雛型の使い方"
author: "suzusime"
documentclass: "yayabook"
papersize: a5
classoption: ["pandoc", "jbase=12Q", "magstyle=nomag*", "jafont=ipaex"]
---

# はじめに
## これは何？
yayabookは「Markdownで書かれた文書をPandocでLaTeX形式に変換し、LuaLaTeXによる処理でPDFを得る」という方法で組版を行うための雛型です。

## 入力に用いるMarkdownの形式
基本的にはPandocによる拡張Markdownを用いますが、以下のオプションを加えています。

`+ignore_line_breaks`
:    改行を半角スペースに変換しません。


## ドキュメントクラス
ドキュメントクラスにはbxjsbook.clsを基にしたyayabook.clsを用います。

# 使用方法
## 依存
- TexLive
    - 動作確認はTeXLive 2018で行っています。必ずしも2018である必要はありませんが、LuaLaTeX(-ja)を利用するためある程度新しい必要があります。
    - フルインストールである必要はありませんが、LuaLaTeXの日本語環境とLatexmkが必要なことに注意してください。
- OMake
    - Windowsにも一応OMakeはインストールできますが、これとWindows版LaTeXを組み合わせると動かないようです。Windowsの場合はWSLを使ってください。
- Pandoc（バージョン2）
    - オプションが一部変わっているのでバージョン2が必要です。Debian stretchのリポジトリにはまだバージョン2がないので、使っている方は別の方法で入れてください。

## 導入
```bash
$ git clone https://github.com/suzusime/yayabook.git && cd yayabook
$ omake  #このサンプル文書をビルドします
```

入力するファイルを`README.md`から変更したい場合は、`OMakefile`を開いて`TARGET`変数を変更してください。

# 原稿の書き方
この章ではPandoc拡張Markdownやyayabookで行っている設定に起因する、通常のMarkdownやTeXの記法との差異として注意する点について解説します。
Pandoc拡張Markdownについての詳細は[公式ドキュメントの日本語訳](http://sky-y.github.io/site-pandoc-jp/users-guide/)を参照してください。
yayabookが内部で呼び出しているbxjsclsについての詳細は、[TeX Wikiのページ](https://texwiki.texjp.org/?BXjscls)及び[公式ドキュメント](https://github.com/zr-tex8r/BXjscls/blob/master/bxjscls-manual.pdf)を参照してください。

## YAMLヘッダ
原稿の題、著者名、およびドキュメントクラスに渡す書式に関する諸情報は、Pandoc拡張MarkdownのYAMLヘッダによって定義します。

たとえばこの文書の場合は次のようになります。

```yaml
---
title: "この雛型の使い方"
author: "suzusime"
documentclass: "yayabook"
papersize: a5
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
実際にこれを試すと[導入](#ux5c0eux5165)のようになります（色がつかずリンクとわかりづらいですが、確かにリンクになっています）。

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

## 他のファイルの挿入
原稿の中に他の原稿ファイル（例えば`article1.md`）を取り込みたい場合は、インラインLaTeX記法（Markdown中に通常のLaTeXの記法で書く）で、

```latex
\include{article1}
```

などと書いてください。
挿入前に改頁を入れたくない場合は

```latex
\include*{article1}
```

のように`*`をつけてください（newcludeパッケージの機能です）。

これだけでは依存ファイルがpandocによりビルドされないので、`OMakefile`の`INCLUDES`にファイル名を拡張子なし、スペース区切りで追記してください。

```
INCLUDES = article1 article2
```

挿入はたとえば次のようになります。

\include*{article1}

## 画像などの挿入
TeXファイルは`./intermediate`ディレクトリの中に生成されますが、
画像その他外部ファイルへの参照の基準は`.`にしてください。

![琵琶を弾いている様子](images/biwa.jpg)

## パッケージの追加方法
YAMLヘッダに

```yaml
header-includes: |
  \usepackage{braket}
  \usepackage{lmodern}
```

のように書き連ねてください。
