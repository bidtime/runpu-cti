object frmDownload: TfrmDownload
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ccgate '#21319#32423#30028#38754' v0.3'
  ClientHeight = 176
  ClientWidth = 556
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
    Left = 23
    Top = 128
    Width = 322
    Height = 15
    AutoSize = False
    Caption = #20934#22791#19979#36733'...'
  end
  object GroupBox1: TGroupBox
    Left = 18
    Top = 19
    Width = 516
    Height = 99
    Caption = #19979#36733#36827#24230
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 32
      Top = 42
      Width = 457
      Height = 17
      TabOrder = 0
    end
    object cbxForce: TCheckBox
      Left = 412
      Top = 70
      Width = 75
      Height = 17
      Caption = #24378#21046#21319#32423
      TabOrder = 1
    end
  end
  object btnDownload: TButton
    Left = 373
    Top = 132
    Width = 75
    Height = 25
    Caption = #21319#32423'(&S)'
    Default = True
    TabOrder = 1
    OnClick = btnDownloadClick
  end
  object btnCancel: TButton
    Left = 460
    Top = 131
    Width = 75
    Height = 25
    Caption = #20013#27490'(&P)'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
