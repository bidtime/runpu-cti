object frmDownload: TfrmDownload
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ccgate '#21319#32423#30028#38754
  ClientHeight = 184
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object lblState: TLabel
    Left = 29
    Top = 126
    Width = 77
    Height = 15
    Caption = #20934#22791#19979#36733'...'
  end
  object GroupBox1: TGroupBox
    Left = 18
    Top = 17
    Width = 516
    Height = 94
    Caption = #19979#36733#36827#24230
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 32
      Top = 42
      Width = 457
      Height = 17
      TabOrder = 0
    end
  end
  object btnDownload: TButton
    Left = 361
    Top = 130
    Width = 75
    Height = 25
    Caption = #19979#36733'(&S)'
    Default = True
    TabOrder = 1
    OnClick = btnDownloadClick
  end
  object btnCancel: TButton
    Left = 448
    Top = 129
    Width = 75
    Height = 25
    Caption = #20013#27490'(&P)'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
