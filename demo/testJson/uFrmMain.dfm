object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 555
  ClientWidth = 869
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
  object Splitter1: TSplitter
    Left = 0
    Top = 225
    Width = 869
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 684
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 869
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 0
    object Button5: TButton
      Left = 0
      Top = 0
      Width = 121
      Height = 22
      Caption = 'memory leak'
      TabOrder = 4
      OnClick = Button5Click
    end
    object ToolButton1: TToolButton
      Left = 121
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Button1: TButton
      Left = 129
      Top = 0
      Width = 75
      Height = 22
      Caption = 'serial'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ToolButton4: TToolButton
      Left = 204
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object Button2: TButton
      Left = 212
      Top = 0
      Width = 75
      Height = 22
      Caption = 'Deserial'
      TabOrder = 1
      OnClick = Button2Click
    end
    object ToolButton2: TToolButton
      Left = 287
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object Button3: TButton
      Left = 295
      Top = 0
      Width = 75
      Height = 22
      Caption = 'S2'
      TabOrder = 2
      OnClick = Button3Click
    end
    object ToolButton3: TToolButton
      Left = 370
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object Button4: TButton
      Left = 378
      Top = 0
      Width = 75
      Height = 22
      Caption = 'D2'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 536
    Width = 869
    Height = 19
    Panels = <>
  end
  object memoCtx: TMemo
    Left = 0
    Top = 29
    Width = 869
    Height = 196
    Align = alTop
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object MemoLog: TMemo
    Left = 0
    Top = 229
    Width = 869
    Height = 307
    Align = alClient
    Lines.Strings = (
      'Memo2')
    TabOrder = 3
  end
end
