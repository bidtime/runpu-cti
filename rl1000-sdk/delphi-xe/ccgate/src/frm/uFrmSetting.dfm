object frmSetting: TfrmSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21442#25968#35774#32622
  ClientHeight = 353
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object btnSave: TButton
    Left = 230
    Top = 315
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnReset: TButton
    Left = 311
    Top = 315
    Width = 75
    Height = 25
    Caption = #37325#32622
    TabOrder = 1
    OnClick = btnResetClick
  end
  object btnClose: TButton
    Left = 392
    Top = 315
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 489
    Height = 308
    ActivePage = TabSheet1
    Align = alTop
    Style = tsFlatButtons
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #36890#29992
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 10
        Top = 2
        Width = 450
        Height = 54
        Caption = #26381#21153
        TabOrder = 0
        object Label7: TLabel
          Left = 12
          Top = 25
          Width = 42
          Height = 12
          Caption = #20027#26426#21517':'
        end
        object Label8: TLabel
          Left = 290
          Top = 26
          Width = 30
          Height = 12
          Caption = #31471#21475':'
        end
        object edtHost: TEdit
          Left = 64
          Top = 22
          Width = 125
          Height = 20
          TabOrder = 0
          Text = '127.0.0.1'
        end
        object spedPort: TSpinEdit
          Left = 355
          Top = 22
          Width = 76
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 10
        Top = 66
        Width = 450
        Height = 84
        Caption = #25320#21495
        TabOrder = 1
        object Label9: TLabel
          Left = 16
          Top = 24
          Width = 54
          Height = 12
          Caption = #20986#23616#21495#30721':'
        end
        object Label10: TLabel
          Left = 290
          Top = 25
          Width = 54
          Height = 12
          Caption = #20998#26426#21495#30721':'
        end
        object Label20: TLabel
          Left = 16
          Top = 55
          Width = 54
          Height = 12
          Caption = #26412#26426#21495#30721':'
        end
        object edtOutPrefix: TEdit
          Left = 78
          Top = 21
          Width = 131
          Height = 20
          TabOrder = 0
        end
        object edtExtNo: TEdit
          Left = 355
          Top = 21
          Width = 76
          Height = 20
          TabOrder = 1
          Text = '1234'
        end
        object edtCallingNo: TEdit
          Left = 78
          Top = 51
          Width = 131
          Height = 20
          TabOrder = 2
          Text = '68761234'
        end
        object cbxAutoRun: TCheckBox
          Left = 290
          Top = 51
          Width = 78
          Height = 17
          Alignment = taLeftJustify
          Caption = #24320#26426#21551#21160
          TabOrder = 3
        end
      end
      object GroupBox8: TGroupBox
        Left = 10
        Top = 161
        Width = 450
        Height = 108
        Caption = #21024#38500#25991#20214
        TabOrder = 2
        object Label21: TLabel
          Left = 16
          Top = 56
          Width = 108
          Height = 12
          Caption = #25195#25551#24405#38899': '#27599#38548'('#20998')'
        end
        object Label22: TLabel
          Left = 257
          Top = 27
          Width = 108
          Height = 12
          Caption = #21024#38500#26085#24535': '#36229#36807'('#22825')'
        end
        object Label24: TLabel
          Left = 257
          Top = 56
          Width = 108
          Height = 12
          Caption = #21024#38500#24405#38899': '#36229#36807'('#22825')'
        end
        object Label19: TLabel
          Left = 16
          Top = 27
          Width = 108
          Height = 12
          Caption = #25195#25551#26085#24535': '#27599#38548'('#20998')'
        end
        object spedDelRecScanInterv: TSpinEdit
          Left = 134
          Top = 52
          Width = 63
          Height = 21
          MaxValue = 720
          MinValue = 5
          TabOrder = 0
          Value = 240
        end
        object spedDelLogInterv: TSpinEdit
          Left = 371
          Top = 22
          Width = 61
          Height = 21
          MaxValue = 36500
          MinValue = 1
          TabOrder = 1
          Value = 45
        end
        object spedDelRecInterv: TSpinEdit
          Left = 371
          Top = 52
          Width = 61
          Height = 21
          MaxValue = 36500
          MinValue = 1
          TabOrder = 2
          Value = 30
        end
        object spedDelLogScanInterv: TSpinEdit
          Left = 134
          Top = 23
          Width = 63
          Height = 21
          MaxValue = 600
          MinValue = 60
          TabOrder = 3
          Value = 300
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #36890#35805
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 11
        Top = 106
        Width = 449
        Height = 87
        Caption = #21387#32553
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 26
          Width = 54
          Height = 12
          Caption = #21387#32553#26684#24335':'
        end
        object cbxRecFileFormat: TComboBox
          Left = 80
          Top = 23
          Width = 346
          Height = 20
          Style = csDropDownList
          TabOrder = 0
        end
        object fileecho: TCheckBox
          Left = 29
          Top = 52
          Width = 81
          Height = 25
          Caption = #22238#38899#25269#28040
          TabOrder = 1
        end
        object fileagc: TCheckBox
          Left = 234
          Top = 52
          Width = 81
          Height = 25
          Caption = #33258#21160#22686#30410
          TabOrder = 2
        end
      end
      object amGroupBox: TGroupBox
        Left = 11
        Top = 207
        Width = 449
        Height = 56
        Caption = #22686#30410
        TabOrder = 1
        object Label3: TLabel
          Left = 16
          Top = 24
          Width = 54
          Height = 12
          Caption = #32819#26426#22686#30410':'
        end
        object Label4: TLabel
          Left = 273
          Top = 24
          Width = 48
          Height = 12
          Caption = 'mic'#22686#30410':'
        end
        object cbxSpkAm: TComboBox
          Left = 80
          Top = 21
          Width = 98
          Height = 20
          Style = csDropDownList
          TabOrder = 0
        end
        object cbxMicAm: TComboBox
          Left = 328
          Top = 21
          Width = 98
          Height = 20
          Style = csDropDownList
          TabOrder = 1
        end
      end
      object GroupBox7: TGroupBox
        Left = 10
        Top = 2
        Width = 450
        Height = 90
        Caption = #24405#38899
        TabOrder = 2
        object Label1: TLabel
          Left = 229
          Top = 29
          Width = 132
          Height = 12
          Caption = #26377#25928#24405#38899#26102#38271': '#36229#36807'('#31186')'
        end
        object cbxAutoCallRec: TCheckBox
          Left = 29
          Top = 21
          Width = 105
          Height = 25
          Caption = #33258#21160#36890#35805#24405#38899
          TabOrder = 0
        end
        object spEditValidPeriod: TSpinEdit
          Left = 365
          Top = 25
          Width = 62
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
        object cbxCallInAutoConfirm: TCheckBox
          Left = 29
          Top = 53
          Width = 105
          Height = 25
          Caption = #26469#30005#33258#21160#30830#35748
          TabOrder = 2
        end
        object cbxDialupAutoConfirm: TCheckBox
          Left = 229
          Top = 53
          Width = 106
          Height = 25
          Caption = #21435#30005#33258#21160#30830#35748
          TabOrder = 3
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #19978#20256
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox5: TGroupBox
        Left = 10
        Top = 191
        Width = 450
        Height = 84
        Caption = #19978#20256#21442#25968
        TabOrder = 0
        object Label11: TLabel
          Left = 16
          Top = 56
          Width = 108
          Height = 12
          Caption = #25195#25551#30446#24405': '#27599#38548'('#20998')'
        end
        object Label12: TLabel
          Left = 258
          Top = 56
          Width = 108
          Height = 12
          Caption = #33258#21160#19978#20256': '#27599#38548'('#31186')'
        end
        object Label17: TLabel
          Left = 16
          Top = 28
          Width = 84
          Height = 12
          Caption = #36830#25509#36229#26102': ('#20998')'
        end
        object spedUpScanInterv: TSpinEdit
          Left = 128
          Top = 52
          Width = 53
          Height = 21
          MaxValue = 240
          MinValue = 5
          TabOrder = 0
          Value = 20
        end
        object spedUpInterv: TSpinEdit
          Left = 374
          Top = 52
          Width = 53
          Height = 21
          MaxValue = 3600000
          MinValue = 15
          TabOrder = 1
          Value = 20
        end
        object spedUpConnTimeOut: TSpinEdit
          Left = 128
          Top = 24
          Width = 53
          Height = 21
          MaxValue = 10
          MinValue = 1
          TabOrder = 2
          Value = 1
        end
      end
      object GroupBox6: TGroupBox
        Left = 10
        Top = 2
        Width = 450
        Height = 80
        Caption = #24405#38899#25991#20214
        TabOrder = 1
        object Label15: TLabel
          Left = 16
          Top = 25
          Width = 30
          Height = 12
          Caption = #22320#22336':'
        end
        object Label13: TLabel
          Left = 258
          Top = 53
          Width = 54
          Height = 12
          Caption = #37325#35797#27425#25968':'
        end
        object Label16: TLabel
          Left = 16
          Top = 53
          Width = 84
          Height = 12
          Caption = #19978#20256#36229#26102': ('#20998')'
        end
        object edtUpResUrl: TEdit
          Left = 52
          Top = 22
          Width = 375
          Height = 20
          TabOrder = 0
        end
        object spedUpResMaxNum: TSpinEdit
          Left = 333
          Top = 48
          Width = 94
          Height = 21
          MaxValue = 50000
          MinValue = 500
          TabOrder = 1
          Value = 10000
        end
        object spedUpResTimeOut: TSpinEdit
          Left = 120
          Top = 48
          Width = 63
          Height = 21
          MaxValue = 60
          MinValue = 1
          TabOrder = 2
          Value = 60
        end
      end
      object GroupBox1: TGroupBox
        Left = 10
        Top = 93
        Width = 450
        Height = 86
        Caption = #36890#35805#20449#24687
        TabOrder = 2
        object Label6: TLabel
          Left = 16
          Top = 28
          Width = 30
          Height = 12
          Caption = #22320#22336':'
        end
        object Label14: TLabel
          Left = 258
          Top = 57
          Width = 54
          Height = 12
          Caption = #37325#35797#27425#25968':'
        end
        object Label5: TLabel
          Left = 16
          Top = 57
          Width = 84
          Height = 12
          Caption = #19978#20256#36229#26102': ('#20998')'
        end
        object edtUpDataUrl: TEdit
          Left = 52
          Top = 23
          Width = 375
          Height = 20
          TabOrder = 0
        end
        object spedUpDataMaxNum: TSpinEdit
          Left = 333
          Top = 53
          Width = 94
          Height = 21
          MaxValue = 50000
          MinValue = 500
          TabOrder = 1
          Value = 10000
        end
        object spedUpDataTimeOut: TSpinEdit
          Left = 120
          Top = 53
          Width = 63
          Height = 21
          MaxValue = 60
          MinValue = 1
          TabOrder = 2
          Value = 60
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #29256#26412
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox9: TGroupBox
        Left = 10
        Top = 2
        Width = 450
        Height = 56
        Caption = #26085#24535
        TabOrder = 0
        object Label27: TLabel
          Left = 18
          Top = 23
          Width = 54
          Height = 12
          Caption = #26085#24535#34892#25968':'
        end
        object Label18: TLabel
          Left = 248
          Top = 23
          Width = 54
          Height = 12
          Caption = #26085#24535#32423#21035':'
        end
        object spedLogMaxLines: TSpinEdit
          Left = 91
          Top = 19
          Width = 76
          Height = 21
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 20
        end
        object cbxLogLevel: TComboBox
          Left = 318
          Top = 19
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 1
          Text = 'info'
          Items.Strings = (
            'debug'
            'info'
            'warn'
            'error')
        end
      end
      object GroupBox10: TGroupBox
        Left = 10
        Top = 67
        Width = 450
        Height = 94
        Caption = #29256#26412
        TabOrder = 1
        object Label26: TLabel
          Left = 12
          Top = 59
          Width = 48
          Height = 12
          Caption = #29256#26412'URL:'
        end
        object Label28: TLabel
          Left = 12
          Top = 29
          Width = 108
          Height = 12
          Caption = #29256#26412#26816#27979': '#27599#38548'('#20998')'
        end
        object edtUpgradeURL: TEdit
          Left = 64
          Top = 55
          Width = 367
          Height = 20
          TabOrder = 0
        end
        object spedUpgradeInterv: TSpinEdit
          Left = 126
          Top = 24
          Width = 63
          Height = 21
          MaxValue = 120
          MinValue = 1
          TabOrder = 1
          Value = 20
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #35774#22791
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox11: TGroupBox
        Left = 5
        Top = 10
        Width = 450
        Height = 95
        Caption = #36890#35805#35774#22791
        TabOrder = 0
        object Label23: TLabel
          Left = 29
          Top = 60
          Width = 320
          Height = 12
          Caption = #27880#65306#24320#21551#33258#21160#22797#20301#65292#21017#35774#22791#36229#36807'5'#31186#19981#21709#24212', '#20250#33258#21160#22797#20301
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbxCtrlWatchDog: TCheckBox
          Left = 29
          Top = 21
          Width = 105
          Height = 25
          Caption = #33258#21160#22797#20301
          TabOrder = 0
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #23384#20648
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbDisk: TGroupBox
        Left = 10
        Top = 2
        Width = 450
        Height = 109
        Caption = #30913#30424#23646#24615
        TabOrder = 0
        object Label25: TLabel
          Left = 16
          Top = 27
          Width = 54
          Height = 12
          Caption = #24050#29992#31354#38388':'
        end
        object Label29: TLabel
          Left = 16
          Top = 49
          Width = 54
          Height = 12
          Caption = #21487#29992#31354#38388':'
        end
        object Label30: TLabel
          Left = 16
          Top = 82
          Width = 54
          Height = 12
          Caption = #24635#20849#23481#37327':'
        end
        object Bevel1: TBevel
          Left = 16
          Top = 72
          Width = 422
          Height = 2
        end
        object LblAvailUnit1: TLabel
          Left = 76
          Top = 26
          Width = 244
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'LblAvailUnit1'
        end
        object LblAvailUnit2: TLabel
          Left = 331
          Top = 26
          Width = 107
          Height = 14
          AutoSize = False
          Caption = 'LblAvailUnit2'
        end
        object LblFreeUnit2: TLabel
          Left = 331
          Top = 48
          Width = 107
          Height = 14
          AutoSize = False
          Caption = 'LblFreeUnit2'
        end
        object LblFreeUnit1: TLabel
          Left = 76
          Top = 48
          Width = 244
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'LblFreeUnit1'
        end
        object lblTotalUnit1: TLabel
          Left = 76
          Top = 81
          Width = 244
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'lblTotalUnit1'
        end
        object lblTotalUnit2: TLabel
          Left = 331
          Top = 81
          Width = 107
          Height = 12
          AutoSize = False
          Caption = 'lblTotalUnit2'
        end
      end
      object GroupBox13: TGroupBox
        Left = 10
        Top = 119
        Width = 450
        Height = 146
        Caption = #24405#38899#25991#20214#30446#24405
        TabOrder = 1
        object Label31: TLabel
          Left = 16
          Top = 24
          Width = 54
          Height = 12
          Caption = #26080#25928#24405#38899':'
        end
        object Label33: TLabel
          Left = 16
          Top = 53
          Width = 66
          Height = 12
          Caption = #24050#19978#20256#24405#38899':'
        end
        object Label32: TLabel
          Left = 16
          Top = 82
          Width = 66
          Height = 12
          Caption = #24453#19978#20256#24405#38899':'
        end
        object Label34: TLabel
          Left = 15
          Top = 110
          Width = 78
          Height = 12
          Caption = #19978#20256#22833#36133#24405#38899':'
        end
        object edtBadDir: TEdit
          Left = 87
          Top = 21
          Width = 327
          Height = 20
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object edtUploadDir: TEdit
          Left = 87
          Top = 49
          Width = 327
          Height = 20
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object Button1: TButton
          Left = 415
          Top = 21
          Width = 22
          Height = 20
          Caption = '...'
          TabOrder = 2
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 415
          Top = 49
          Width = 22
          Height = 20
          Caption = '...'
          TabOrder = 3
          OnClick = Button2Click
        end
        object edtCallDir: TEdit
          Left = 87
          Top = 78
          Width = 327
          Height = 20
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
        object Button3: TButton
          Left = 415
          Top = 78
          Width = 22
          Height = 20
          Caption = '...'
          TabOrder = 5
          OnClick = Button3Click
        end
        object edtFailDir: TEdit
          Left = 99
          Top = 106
          Width = 314
          Height = 20
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
        end
        object Button4: TButton
          Left = 414
          Top = 106
          Width = 22
          Height = 20
          Caption = '...'
          TabOrder = 7
          OnClick = Button4Click
        end
      end
    end
  end
end
