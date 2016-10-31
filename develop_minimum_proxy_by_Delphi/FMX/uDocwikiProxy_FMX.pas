unit uDocwikiProxy_FMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdCmdTCPServer,
  IdHTTPProxyServer, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Controls.Presentation, IdServerIOHandler, IdServerIOHandlerSocket,
  IdServerIOHandlerStack, RegularExpressions;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Switch1: TSwitch;
    Label1: TLabel;
    Memo1: TMemo;
    IdHTTPProxyServer1: TIdHTTPProxyServer;
    IdServerIOHandlerStack1: TIdServerIOHandlerStack;
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPProxyServer1HTTPBeforeCommand(
      AContext: TIdHTTPProxyServerContext);
    procedure IdHTTPProxyServer1HTTPResponse(
      AContext: TIdHTTPProxyServerContext);
  private
    { private 宣言 }
    // 削除対象のヘッダ情報のリスト。
    // 今回の実装ではForm.Createで初期化する。
    HeaderList: TStringList;

    // 指定されたヘッダをMemoに出力する処理。
    procedure WriteToMemo(AHeaderName: String; AHeaderValue: String);
  public
    { public 宣言 }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
{
  フォーム生成時の処理
  ・削除対象のレスポンスヘッダ名のリストを初期化する。
}
begin
  HeaderList := TSTringList.Create;
  HeaderList.CommaText := 'Expires,Pragma,Vary';
end;

procedure TForm1.IdHTTPProxyServer1HTTPBeforeCommand(
  AContext: TIdHTTPProxyServerContext);
{ クライアントからのリクエスト受信時の処理 }
begin
  {
    リクエストヘッダに関する処理を行いたいにここで処理可能。
    以下の例はリクエストヘッダに含まれる Cache-Control ヘッダを消去する処理。

    if (AContext.Headers.IndexOfName('Cache-Control') > 0)  then
      AContext.Headers.Delete( AContext.Headers.IndexOfName('Cache-Control') );
    end;
  }
end;

procedure TForm1.IdHTTPProxyServer1HTTPResponse(
  AContext: TIdHTTPProxyServerContext);
{ サーバからのレスポンスをクライアントに返す前に行う処理 }
var
  NameIndex: Integer;
  i: Integer;
begin
  // ブラウザキャッシュを阻害するヘッダの削除を行う処理。
  // 接続先が docwiki.embarcadero.com 以外ならばここで終了
  if (not AContext.Target.startsWith('http://docwiki.embarcadero.com') ) then
    exit;

  // Switch1 が On (動作の詳細表示有効) ならば、空行を１行差し込む。
  // これはレイアウト調整を目的としている。
  if Switch1.isChecked then
    Memo1.Lines.Insert(0, ' ');

  // リクエストされたURLをログ用の Memo の先頭行に差し込む。
  Memo1.Lines.Insert(0, AContext.Target);

  // 削除対象の HTTP レスポンスヘッダを探して消す。
  // ただし Cache-Control は別の個所で処理する。
  for NameIndex := 0 to HeaderList.Count - 1 do begin
    if (AContext.Headers.IndexOfName(HeaderList[NameIndex]) > 0)  then
    begin
      WriteToMemo( ' remove ' + HeaderList[NameIndex] ,AContext.Headers.Values[HeaderList[NameIndex]] );
      AContext.Headers.Delete( AContext.Headers.IndexOfName(HeaderList[NameIndex]) );
    end;
  end;

  // Cache-Control については、private の場合だけ消す。
  if ( Length(AContext.Headers.Values['Cache-Control']) > 0 ) then
    if TRegEx.IsMatch(AContext.Headers.Values['Cache-Control'],'[Pp]rivate') then
    begin
      WriteToMemo( ' remove Cache-Control', AContext.Headers.Values['Cache-Control'] );
      AContext.Headers.Delete( AContext.Headers.IndexOfName('Cache-Control') );
    end;

end;

procedure TForm1.WriteToMemo(AHeaderName, AHeaderValue: String);
begin
  // Switch1 がチェックされていない場合は処理を行わない。
  if not Switch1.isChecked then
    exit;

  if AHeaderValue.Length > 0 then
    Memo1.Lines.Insert(1, AHeaderName + ' = ' + AHeaderValue);
end;

end.
