object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #36816#36890#30005#35805#30418#23376#32593#20851' ver 0.1'
  ClientHeight = 412
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 318
    Top = 240
    Width = 273
    Height = 158
    Caption = #25511#21046
    TabOrder = 0
    object dohook: TCheckBox
      Left = 16
      Top = 22
      Width = 113
      Height = 25
      Caption = #25688#26426'/'#25509#21548
      TabOrder = 0
      OnClick = dohookClick
    end
    object dophone: TCheckBox
      Left = 16
      Top = 48
      Width = 113
      Height = 25
      Caption = #26029#24320#30005#35805#26426
      TabOrder = 1
      OnClick = dophoneClick
    end
    object linetospk: TCheckBox
      Left = 16
      Top = 75
      Width = 161
      Height = 25
      Caption = #25171#24320#32447#36335#22768#38899#21040#32819#26426
      TabOrder = 2
    end
    object playtospk: TCheckBox
      Left = 16
      Top = 101
      Width = 161
      Height = 25
      Caption = #25773#25918#30340#22768#38899#21040#32819#26426
      TabOrder = 3
    end
    object mictoline: TCheckBox
      Left = 16
      Top = 127
      Width = 161
      Height = 25
      Caption = #25171#24320'mic'#22768#38899#21040#32447#36335
      TabOrder = 4
    end
  end
  object memoMsg: TMemo
    Left = 17
    Top = 12
    Width = 574
    Height = 213
    Lines.Strings = (
      'memoMsg')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 15
    Top = 240
    Width = 293
    Height = 158
    Caption = #36890#36947
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 29
      Width = 28
      Height = 13
      Caption = #36890#36947':'
    end
    object dialcode: TLabel
      Left = 16
      Top = 68
      Width = 28
      Height = 13
      Caption = #21495#30721':'
    end
    object channellist: TComboBox
      Left = 64
      Top = 26
      Width = 118
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object pstncode: TEdit
      Left = 64
      Top = 62
      Width = 118
      Height = 21
      TabOrder = 1
      Text = '67867862'
    end
    object dial: TButton
      Left = 193
      Top = 60
      Width = 75
      Height = 25
      Caption = #25320#21495
      TabOrder = 2
      OnClick = dialClick
    end
    object refusecallin: TButton
      Left = 193
      Top = 97
      Width = 75
      Height = 25
      Caption = #25298#25509#26469#30005
      TabOrder = 3
      OnClick = refusecallinClick
    end
    object btnSetParam: TButton
      Left = 193
      Top = 21
      Width = 75
      Height = 25
      Caption = #21442#25968
      TabOrder = 4
      OnClick = btnSetParamClick
    end
  end
end
