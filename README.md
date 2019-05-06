---
title: "この雛型の使い方"
author: "suzusime"
documentclass: "yayabook"
papersize: a5
classoption: ["pandoc", "jbase=12Q", "magstyle=nomag*", "jafont=ipaex"]
header-includes: |
  \usepackage{braket}
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
- [TexLive](https://tug.org/texlive/)
    - 動作確認はTeXLive 2018で行っています。必ずしも2018である必要はありませんが、LuaLaTeX(-ja)を利用するためある程度新しい必要があります。
    - フルインストールである必要はありませんが、LuaLaTeXの日本語環境とLatexmkが必要なことに注意してください。
- [Rake](https://github.com/ruby/rake)
    - Rubyをインストールすると標準でついてきます。
- [Pandoc](https://pandoc.org/)
    - バージョン1系とバージョン2系とでコマンドラインオプションが一部変わっていますが、自動で判別して適切なオプションで呼びます。

## 導入 {#install}
```bash
$ git clone https://github.com/suzusime/yayabook.git && cd yayabook
$ rake  #このサンプル文書をビルドします
```

入力するファイルを`README.md`から変更したい場合は、`Rakefile`を開いて`TARGET`変数を変更してください。

ファイルの更新があったときに自動でビルドするようにしたい場合は、
```bash
$ rake cont
```
としてください[^1]。
この場合はTeXでの処理中にエラーが発生しても無視して続行します。

[^1]: `NONSTOP=1 rake`を定期的に叩いているだけなので、シェルの機能でループさせても同じですが……

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
実際にこれを試すと[導入](#install)のようになります（色がつかずリンクとわかりづらいですが、確かにリンクになっています）。

上では

> 見出しにつくラベル（参照に用いる）は自動的に生成されますが、
  日本語の場合Unicodeコードポイントを数字で表したものに変換されてしまいます。
  これが困る場合は

と書きましたが、実際はこれで困ることはなさそうです。

というのも、参照する側も同じく（TeX処理系での問題がない）ASCII表現になるからで、単に

```markdown
[依存]
```

と書けば、[依存]とリンクになります。

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

`\include`または`\include*`で挿入した場合は、自動でそれを検出してpandocで変換します。
それ以外の方法により挿入する場合は、`Rakefile`の`ADDITIONAL_INCLUDES`にファイル名をRubyの配列形式で書き込んでください。

```ruby
# append1.mdとappend2.mdを追加したいとき
ADDITIONAL_INCLUDES = ["append1", "append2"]
```

挿入はたとえば次のようになります。

\include*{article1}
\include*{article3}

## 画像などの挿入
TeXファイルは`./intermediate`ディレクトリの中に生成されますが、
画像その他外部ファイルへの参照の基準は`.`にしてください。

![琵琶を弾いている様子](images/biwa.jpg){ width=50mm }

## パッケージの追加方法
YAMLヘッダに

```yaml
header-includes: |
  \usepackage{braket}
  \usepackage{lmodern}
```

のように書き連ねてください。

## 数式の書き方
通常のTeXと同じように、文中で`$\psi (x) = \braket{x|\psi}$`のように書けば$\psi (x) = \braket{x|\psi}$になります。
別行立て数式も
```tex
$$ \sqrt{\frac{\pi}{a}} = \int _{-\infty} ^{\infty} e^{-ax^2} dx $$
```
と書いてやれば
$$ \sqrt{\frac{\pi}{a}} = \int _{-\infty} ^{\infty} e^{-ax^2} dx $$
となるなど、TeXと同じです。
