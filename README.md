見出し改行補正.js
=================

見出しの改行をブラウザまかせにせず、多少自力で頑張ってみる試みです。

助詞などを連結させた「改行を入れることができる単位で分割された文」を学習データとし
<a href="https://github.com/shogo82148/TinySegmenterMaker">TinySegmenterMaker</a>
でモデルを作り、TinySegmenter としています。

この分割単位で見出しを改行するようなプログラムをクライアントサイドで実行させます。

## ファイル

### ./balance.js

メインスクリプト

### ./tinysegmenter.js

TinySegmenterMaker で生成した TinySegmenter。

学習データは自分の日記の過去ログなので汎用性はありません。

### ./corpus.pl

学習データを作るためのスクリプトです。

MeCab でコーパスを形態素解析したのち、助詞などを調整することで改行位置単位の区切りデータを生成します。
