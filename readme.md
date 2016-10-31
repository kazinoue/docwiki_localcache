# Force local cacheing for docwiki.embarcadero.com

## With Squid

docwiki.embarcadero.com のコンテンツをローカルキャッシュするために Squid for Windows を利用する場合の設定例です。

using_squid 以下に設定を配置しています。以下の設定例があります。

1. リバースプロキシ (localhost:80 へのアクセスを docwiki.embarcadero.com に転送する)
1. フォワードプロキシ (localhost:3128　でプロキシを動かす)

### 設定ファイル利用時の注意事項
この設定ファイルは、d:\Squid に Squid for Windows をインストールする前提で作成しています。インストールパスが異なる場合は設定ファイルを調整してください。

### リバースプロキシ (localhost:80 へのアクセスを docwiki.embarcadero.com に転送する)
1. /etc/squid/squid.conf.accel を　squid.conf　にコピー０します。
1. /etc/squid/hosts はそのまま使用します。（中身は空のままで差支えありません）
1. squid.exe -z を実行して、squid のキャッシュディレクトリの初期化を行います。
1. squid を起動し、127.0.0.1:80 でプロセスが Listen していることを確認してください。
1. c:\windows\system32\drivers\etc\hosts に "127.0.0.1 docwiki.embarcadero.com
" の記述を追記してください。

### フォワードプロキシ (localhost:3128 でプロキシを動かす)
1. /etc/squid/squid.conf.forward を　squid.conf　にコピー０します。
1. /etc/squid/hosts はそのまま使用します。（中身は空のままで差支えありません）
1. squid.exe -z を実行して、squid のキャッシュディレクトリの初期化を行います。
1. squid を起動し、127.0.0.1:80 でプロセスが Listen していることを確認してください。
1. proxy.pac をブラウザの自動プロキシ設定から参照するように設定します。

### 動作確認
1. ブラウザより　http://docwiki.embarcadero.com/ にアクセスし、コンテンツが表示されることを確認します。
1. Bash for Windows がインストール済みの場合は "tail -f /mnt/d/Squid/var/log/squid/access.log" などと実行してログをモニタリングします。同じURLに２回目にアクセスすると TCP_HIT や TCP_MEM_HIT などの表示が確認できるはずです。


## Develop minimum proxy by Delphi

Delphi の TIdHTTPProxyServer コンポーネントを用いてプロキシサーバを作り、その中でリクエストヘッダやレスポンスヘッダを加工するサンプルプロジェクトです。

フレームワークは VCL / FireMonkey の両方で作成しています。FireMonkey版は macOS 向けにもビルド可能です。

