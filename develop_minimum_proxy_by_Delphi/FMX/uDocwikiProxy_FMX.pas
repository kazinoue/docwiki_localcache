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
    { private �錾 }
    // �폜�Ώۂ̃w�b�_���̃��X�g�B
    // ����̎����ł�Form.Create�ŏ���������B
    HeaderList: TStringList;

    // �w�肳�ꂽ�w�b�_��Memo�ɏo�͂��鏈���B
    procedure WriteToMemo(AHeaderName: String; AHeaderValue: String);
  public
    { public �錾 }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

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
{ �N���C�A���g����̃��N�G�X�g��M���̏��� }
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
  if Switch1.isChecked then
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

procedure TForm1.WriteToMemo(AHeaderName, AHeaderValue: String);
begin
  // Switch1 ���`�F�b�N����Ă��Ȃ��ꍇ�͏������s��Ȃ��B
  if not Switch1.isChecked then
    exit;

  if AHeaderValue.Length > 0 then
    Memo1.Lines.Insert(1, AHeaderName + ' = ' + AHeaderValue);
end;

end.
