object Form1: TForm1
  Left = 579
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'CC301'#24320#21457#28436#31034#31243#24207' L 1.71'
  ClientHeight = 682
  ClientWidth = 981
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 333
    Width = 30
    Height = 12
    Caption = #36890#36947':'
  end
  object dialcode: TLabel
    Left = 16
    Top = 377
    Width = 30
    Height = 12
    Caption = #21495#30721':'
  end
  object Label2: TLabel
    Left = 16
    Top = 485
    Width = 78
    Height = 12
    Caption = #25991#20214#21387#32553#26684#24335':'
  end
  object opendev: TButton
    Left = 8
    Top = 285
    Width = 89
    Height = 33
    Caption = #25171#24320#35774#22791
    TabOrder = 0
    OnClick = opendevClick
  end
  object closedev: TButton
    Left = 104
    Top = 285
    Width = 89
    Height = 33
    Caption = #20851#38381#35774#22791
    TabOrder = 1
    OnClick = closedevClick
  end
  object btnStartDial: TButton
    Left = 192
    Top = 369
    Width = 81
    Height = 25
    Caption = #24320#22987#25320#21495
    TabOrder = 2
    OnClick = btnStartDialClick
  end
  object playfile: TButton
    Left = 16
    Top = 435
    Width = 97
    Height = 33
    Caption = #25773#25918#25991#20214
    TabOrder = 3
    OnClick = playfileClick
  end
  object GroupBox1: TGroupBox
    Left = 328
    Top = 284
    Width = 641
    Height = 249
    Caption = #25511#21046
    TabOrder = 4
    object dophone: TCheckBox
      Left = 16
      Top = 55
      Width = 81
      Height = 25
      Caption = #36830#25509#32447#36335
      TabOrder = 0
    end
    object linetospk: TCheckBox
      Left = 16
      Top = 91
      Width = 161
      Height = 25
      Caption = #25171#24320#32447#36335#22768#38899#21040#32819#26426
      TabOrder = 1
      OnClick = linetospkClick
    end
    object playtospk: TCheckBox
      Left = 16
      Top = 127
      Width = 145
      Height = 25
      Caption = #25773#25918#30340#22768#38899#21040#32819#26426
      TabOrder = 2
      OnClick = playtospkClick
    end
    object mictoline: TCheckBox
      Left = 16
      Top = 163
      Width = 161
      Height = 25
      Caption = #25171#24320'mic'#22768#38899#21040#32447#36335
      TabOrder = 3
      OnClick = mictolineClick
    end
    object opendoplay: TCheckBox
      Left = 16
      Top = 199
      Width = 89
      Height = 25
      Caption = #25171#24320#21895#21485
      TabOrder = 4
      OnClick = opendoplayClick
    end
    object doplaymux: TComboBox
      Left = 104
      Top = 202
      Width = 145
      Height = 20
      Style = csDropDownList
      TabOrder = 5
      OnChange = doplaymuxChange
    end
    object btnDoPhone: TButton
      Left = 137
      Top = 54
      Width = 75
      Height = 25
      Caption = 'doPhone'
      TabOrder = 6
      OnClick = btnDoPhoneClick
    end
    object btnDoHook: TButton
      Left = 136
      Top = 25
      Width = 75
      Height = 25
      Caption = 'doHook'
      TabOrder = 7
      OnClick = btnDoHookClick
    end
    object dohook: TCheckBox
      Left = 16
      Top = 24
      Width = 81
      Height = 25
      Caption = #30005#35805#25688#26426
      TabOrder = 8
    end
  end
  object recfile: TButton
    Left = 16
    Top = 565
    Width = 97
    Height = 33
    Caption = #25991#20214#24405#38899
    TabOrder = 5
    OnClick = recfileClick
  end
  object channellist: TComboBox
    Left = 64
    Top = 333
    Width = 129
    Height = 20
    Style = csDropDownList
    TabOrder = 6
  end
  object refusecallin: TButton
    Left = 16
    Top = 629
    Width = 97
    Height = 33
    Caption = #25298#25509#26469#30005
    TabOrder = 7
    OnClick = refusecallinClick
  end
  object startflash: TButton
    Left = 152
    Top = 629
    Width = 97
    Height = 33
    Caption = #25293#25554#31783
    TabOrder = 8
    OnClick = startflashClick
  end
  object pstncode: TEdit
    Left = 64
    Top = 371
    Width = 121
    Height = 20
    TabOrder = 9
    Text = '67867862'
  end
  object stopplayfile: TButton
    Left = 176
    Top = 435
    Width = 97
    Height = 33
    Caption = #20572#27490#25773#25918
    TabOrder = 10
    OnClick = stopplayfileClick
  end
  object stoprecfile: TButton
    Left = 152
    Top = 565
    Width = 97
    Height = 33
    Caption = #20572#27490#24405#38899
    TabOrder = 11
    OnClick = stoprecfileClick
  end
  object fileecho: TCheckBox
    Left = 16
    Top = 533
    Width = 81
    Height = 25
    Caption = #22238#38899#25269#28040
    TabOrder = 12
  end
  object fileagc: TCheckBox
    Left = 112
    Top = 533
    Width = 81
    Height = 25
    Caption = #33258#21160#22686#30410
    TabOrder = 13
  end
  object recfileformat: TComboBox
    Left = 16
    Top = 509
    Width = 265
    Height = 20
    Style = csDropDownList
    TabOrder = 14
  end
  object amGroupBox: TGroupBox
    Left = 328
    Top = 548
    Width = 641
    Height = 89
    Caption = #22686#30410
    TabOrder = 15
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 12
      Caption = #32819#26426#22686#30410':'
    end
    object Label4: TLabel
      Left = 16
      Top = 56
      Width = 48
      Height = 12
      Caption = 'mic'#22686#30410':'
    end
    object spkam: TComboBox
      Left = 88
      Top = 24
      Width = 121
      Height = 20
      Style = csDropDownList
      TabOrder = 0
      OnChange = spkamChange
    end
    object micam: TComboBox
      Left = 88
      Top = 56
      Width = 121
      Height = 20
      Style = csDropDownList
      TabOrder = 1
      OnChange = micamChange
    end
  end
  object startspeech: TButton
    Left = 328
    Top = 643
    Width = 129
    Height = 25
    Caption = #24320#22987#20869#32447#35821#38899#35782#21035
    TabOrder = 16
    OnClick = startspeechClick
  end
  object Button2: TButton
    Left = 472
    Top = 643
    Width = 113
    Height = 25
    Caption = #20572#27490#35782#21035
    TabOrder = 17
    OnClick = Button2Click
  end
  object btnStopDial: TButton
    Left = 191
    Top = 397
    Width = 81
    Height = 25
    Caption = #32467#26463#25320#21495
    TabOrder = 18
    OnClick = btnStopDialClick
  end
  object memoLog: TMemo
    Left = 8
    Top = 8
    Width = 961
    Height = 270
    Lines.Strings = (
      'memoLog')
    ScrollBars = ssBoth
    TabOrder = 19
  end
  object btnClearLog: TButton
    Left = 199
    Top = 285
    Width = 89
    Height = 33
    Caption = #28165#38500#26085#24535
    TabOrder = 20
    OnClick = btnClearLogClick
  end
  object playfiledialog: TOpenDialog
    Filter = 'wave|*.wav;*.wave;*.pcm|all files|*.*'
    Left = 120
    Top = 435
  end
  object recfiledialog: TSaveDialog
    Filter = 'wave files|*.wav|all files|*.*'
    Left = 120
    Top = 573
  end
end
