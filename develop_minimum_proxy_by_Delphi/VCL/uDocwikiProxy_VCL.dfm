object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 640
    Height = 439
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 564
      Height = 39
      Align = alClient
      Caption = 'output log to memo'
      ExplicitWidth = 93
      ExplicitHeight = 13
    end
    object ToggleSwitch1: TToggleSwitch
      Left = 565
      Top = 1
      Width = 74
      Height = 39
      Align = alRight
      TabOrder = 0
      ExplicitHeight = 20
    end
  end
  object IdHTTPProxyServer1: TIdHTTPProxyServer
    Active = True
    Bindings = <>
    DefaultPort = 3128
    IOHandler = IdServerIOHandlerStack1
    CommandHandlers = <>
    ExceptionReply.Code = '500'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Greeting.Code = '200'
    HelpReply.Code = '100'
    HelpReply.Text.Strings = (
      'Help follows')
    MaxConnectionReply.Code = '300'
    MaxConnectionReply.Text.Strings = (
      'Too many connections. Try again later.')
    ReplyTexts = <>
    ReplyUnknownCommand.Code = '400'
    DefaultTransferMode = tmStreaming
    OnHTTPBeforeCommand = IdHTTPProxyServer1HTTPBeforeCommand
    OnHTTPResponse = IdHTTPProxyServer1HTTPResponse
    Left = 264
    Top = 64
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 120
    Top = 64
  end
  object IdServerIOHandlerStack1: TIdServerIOHandlerStack
    Left = 392
    Top = 64
  end
end
