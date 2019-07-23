object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 500
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblState: TLabel
    Left = 56
    Top = 96
    Width = 60
    Height = 13
    Caption = #20934#22791#19979#36733'...'
  end
  object Edit1: TEdit
    Left = 56
    Top = 24
    Width = 377
    Height = 21
    TabOrder = 0
    Text = 'http://172.16.200.225:81/file_up/fileupload.zip____'
  end
  object btnStart: TButton
    Left = 448
    Top = 22
    Width = 75
    Height = 25
    Caption = 'download'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object ProgressBar1: TProgressBar
    Left = 56
    Top = 64
    Width = 467
    Height = 17
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 56
    Top = 128
    Width = 377
    Height = 21
    TabOrder = 3
    Text = 'http://172.16.200.225:81/file_up/upgrade.inf?verNo=0.01'
  end
  object btnCheckDl: TButton
    Left = 448
    Top = 126
    Width = 75
    Height = 25
    Caption = 'btnCheckDl'
    TabOrder = 4
    OnClick = btnCheckDlClick
  end
  object Memo1: TMemo
    Left = 56
    Top = 184
    Width = 377
    Height = 289
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
  object btnUnzip: TButton
    Left = 552
    Top = 87
    Width = 75
    Height = 25
    Caption = 'unzip'
    TabOrder = 6
    OnClick = btnUnzipClick
  end
  object btnZip: TButton
    Left = 448
    Top = 87
    Width = 75
    Height = 25
    Caption = 'zip'
    TabOrder = 7
    OnClick = btnZipClick
  end
  object btnFileAge: TButton
    Left = 552
    Top = 128
    Width = 75
    Height = 25
    Caption = 'btnFileAge'
    TabOrder = 8
  end
  object btnRemove: TButton
    Left = 448
    Top = 168
    Width = 75
    Height = 25
    Caption = 'btnRemove'
    TabOrder = 9
    OnClick = btnRemoveClick
  end
  object Button1: TButton
    Left = 536
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 10
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 544
    Top = 336
  end
end
