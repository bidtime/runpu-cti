object frmMain: TfrmMain
  Left = 297
  Top = 220
  Caption = 'frmMain'
  ClientHeight = 430
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 411
    Width = 716
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    ExplicitTop = 405
    ExplicitWidth = 711
  end
  object MainMenu1: TMainMenu
    Left = 376
    Top = 256
    object menuFile: TMenuItem
      Caption = #25991#20214'(&F)'
      object S1: TMenuItem
        Action = actnStart
      end
      object T1: TMenuItem
        Action = actnEnd
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object actnSetting1: TMenuItem
        Action = actnSetting
      end
      object C1: TMenuItem
        Action = actnClear
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuExit: TMenuItem
        Action = FileExit1
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A1: TMenuItem
        Action = actnAbout
      end
    end
  end
  object ActionList1: TActionList
    Left = 304
    Top = 256
    object actnStart: TAction
      Caption = #21551#21160'(&S)'
      OnExecute = actnStartExecute
      OnUpdate = actnStartUpdate
    end
    object actnEnd: TAction
      Caption = #20572#27490'(&T)'
      OnExecute = actnEndExecute
      OnUpdate = actnEndUpdate
    end
    object actnClear: TAction
      Caption = #28165#38500'(&C)'
      OnExecute = actnClearExecute
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = #36864#20986'(&E)'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object actnSetting: TAction
      Caption = #35774#32622'(&P)'
      OnExecute = actnSettingExecute
    end
    object actnAbout: TAction
      Caption = #20851#20110'(&A)'
      OnExecute = actnAboutExecute
    end
  end
  object PopupMenu: TPopupMenu
    Left = 440
    Top = 256
    object miProperties: TMenuItem
      Caption = #26174'/'#34255'(&S)'
      Default = True
      OnClick = miPropertiesClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object miClose: TMenuItem
      Caption = #36864#20986'(&E)'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
      OnClick = miCloseClick
    end
  end
  object TrayIcon1: TTrayIcon
    Visible = True
    OnDblClick = TrayIcon1DblClick
    OnMouseDown = TrayIcon1MouseDown
    Left = 512
    Top = 256
  end
end
