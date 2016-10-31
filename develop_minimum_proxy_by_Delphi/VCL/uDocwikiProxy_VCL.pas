unit uDocwikiProxy_VCL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTPProxyServer, IdCmdTCPServer,
  IdContext, IdServerIOHandler, IdServerIOHandlerSocket, IdServerIOHandlerStack,
  IdAntiFreezeBase, Vcl.IdAntiFreeze, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdTCPServer, Vcl.WinXCtrls, Vcl.ExtCtrls,
  RegularExpressions;

type
  TForm1 = class(TForm)
    IdHTTPProxyServer1: TIdHTTPProxyServer;
    Memo1: TMemo;
    IdAntiFreeze1: TIdAntiFreeze;
    IdServerIOHandlerStack1: TIdServerIOHandlerStack;
    Panel1: TPanel;
    ToggleSwitch1: TToggleSwitch;
    Label1: TLabel;
    procedure IdHTTPProxyServer1HTTPResponse(
      AContext: TIdHTTPProxyServerContext);
    procedure IdHTTPProxyServer1HTTPBeforeCommand(
      AContext: TIdHTTPProxyServerContext);
    procedure FormCreate(Sender: TObject);
  private
    { Private �錾 }
    FlagResponseHeaderStrip: Boolean;
    HeaderList: TStringList;

    procedure WriteToMemo(AHeaderName: String; AHeaderValue: String);
  public
    { Public �錾 }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
{
  �t�H�[���������̏���
  �E�폜�Ώۂ̃��X�|���X�w�b�_���̃��X�g������������B
}
begin
  HeaderList := TSTringList.Create;
  HeaderList.CommaText := 'Expires,Pragma,Vary';
end;

procedure TForm1.IdHTTPProxyServer1HTTPBeforeCommand(
  AContext: TIdHTTPProxyServerContext);
{
  �N���C�A���g����̃��N�G�X�g��M���̏���
}
begin
  {
    ���N�G�X�g�w�b�_�Ɋւ��鏈�����s�������ɂ����ŏ����\�B
    �ȉ��̗�̓��N�G�X�g�w�b�_�Ɋ܂܂�� Cache-Control �w�b�_���������鏈���B

    if (AContext.Headers.IndexOfName('Cache-Control') > 0)  then
      AContext.Headers.Delete( AContext.Headers.IndexOfName('Cache-Control') );
    end;
  }
end;


procedure TForm1.IdHTTPProxyServer1HTTPResponse(
  AContext: TIdHTTPProxyServerContext);
{ �T�[�o����̃��X�|���X���N���C�A���g�ɕԂ��O�ɍs������ }
var
  NameIndex: Integer;
  i: Integer;
begin
  // �u���E�U�L���b�V����j�Q����w�b�_�̍폜���s�������B
  // �ڑ��悪 docwiki.embarcadero.com �ȊO�Ȃ�΂����ŏI��
  if (not AContext.Target.startsWith('http://docwiki.embarcadero.com') ) then
    exit;

  // Switch1 �� On (����̏ڍו\���L��) �Ȃ�΁A��s���P�s�������ށB
  // ����̓��C�A�E�g������ړI�Ƃ��Ă���B
  if ToggleSwitch1.isOn then
    Memo1.Lines.Insert(0, ' ');

  // ���N�G�X�g���ꂽURL�����O�p�� Memo �̐擪�s�ɍ������ށB
  Memo1.Lines.Insert(0, AContext.Target);

  // �폜�Ώۂ� HTTP ���X�|���X�w�b�_��T���ď����B
  // ������ Cache-Control �͕ʂ̌��ŏ�������B
  for NameIndex := 0 to HeaderList.Count - 1 do begin
    if (AContext.Headers.IndexOfName(HeaderList[NameIndex]) > 0)  then
    begin
      WriteToMemo( ' remove ' + HeaderList[NameIndex] ,AContext.Headers.Values[HeaderList[NameIndex]] );
      AContext.Headers.Delete( AContext.Headers.IndexOfName(HeaderList[NameIndex]) );
    end;
  end;

  // Cache-Control �ɂ��ẮAprivate �̏ꍇ���������B
  if ( Length(AContext.Headers.Values['Cache-Control']) > 0 ) then
    if TRegEx.IsMatch(AContext.Headers.Values['Cache-Control'],'[Pp]rivate') then
    begin
      WriteToMemo( ' remove Cache-Control', AContext.Headers.Values['Cache-Control'] );
      AContext.Headers.Delete( AContext.Headers.IndexOfName('Cache-Control') );
    end;

end;

procedure TForm1.WriteToMemo(AHeaderName: string; AHeaderValue: string);
{ TMemo �ւ̃��b�Z�[�W�����o������ }
begin
  // Switch1 ���`�F�b�N����Ă��Ȃ��ꍇ�͏������s��Ȃ��B
  if not ToggleSwitch1.isOn then
    exit;

  if AHeaderValue.Length > 0 then
    Memo1.Lines.Insert(1, AHeaderName + ' = ' + AHeaderValue);
end;

end.
