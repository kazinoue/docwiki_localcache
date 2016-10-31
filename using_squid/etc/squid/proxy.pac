/*
Proxy 自動設定ファイルの例

この設定ファイルをブラウザに設定しておくと、docwiki.embarcadero.com へのアクセスだけは
自ホスト上で動作するフォワードプロキシを経由します。

そのほかのリクエストはすべて直接接続を試みます。

ネットワーク構成により適時調整してください。
*/



function FindProxyForURL(url, host)
{
	if (shExpMatch(host, "docwiki.embarcadero.com"))
		return "PROXY localhost:3128";
	else
		return "DIRECT";
}