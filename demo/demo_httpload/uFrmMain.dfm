object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 644
  ClientWidth = 859
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 361
    Width = 859
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 257
  end
  object memoResult: TMemo
    Left = 0
    Top = 365
    Width = 859
    Height = 279
    Align = alClient
    Lines.Strings = (
      'memoResult')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 859
    Height = 361
    Align = alTop
    Caption = 'GroupBox1'
    TabOrder = 1
    object btnWavJson: TButton
      Left = 744
      Top = 39
      Width = 75
      Height = 25
      Caption = 'wav _data'
      TabOrder = 0
      OnClick = btnWavJsonClick
    end
    object PageControl1: TPageControl
      Left = 8
      Top = 18
      Width = 715
      Height = 334
      ActivePage = TabSheet6
      TabOrder = 1
      object TabSheet1: TTabSheet
        Caption = 'test json'
        inline frameUrlParam1: TframeUrlParam
          Left = 6
          Top = 3
          Width = 661
          Height = 313
          TabOrder = 0
          ExplicitLeft = 6
          ExplicitTop = 3
          ExplicitWidth = 661
          ExplicitHeight = 313
          inherited memoCtx: TMemo
            Lines.Strings = (
              '{'
              '  "id":1,'
              '  "name": "xx1"'
              '}')
          end
          inherited edtUrl: TEdit
            Text = 'http://172.16.200.233:8082/api/cr/callrecord/runpu/ori/test'
          end
          inherited Button2: TButton
            OnClick = frameUrlParam1Button2Click
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'test strs'
        ImageIndex = 1
        inline frameUrlParam2: TframeUrlParam
          Left = 4
          Top = 2
          Width = 661
          Height = 313
          TabOrder = 0
          ExplicitLeft = 4
          ExplicitTop = 2
          ExplicitWidth = 661
          ExplicitHeight = 313
          inherited memoCtx: TMemo
            Lines.Strings = (
              'id=2'
              'name=xx2')
          end
          inherited edtUrl: TEdit
            Text = 'http://172.16.200.233:8082/api/cr/callrecord/runpu/ori/test/1'
          end
          inherited Button2: TButton
            OnClick = frameUrlParam2Button2Click
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'update json'
        ImageIndex = 2
        inline frameUrlParam3: TframeUrlParam
          Left = 4
          Top = 2
          Width = 661
          Height = 307
          TabOrder = 0
          ExplicitLeft = 4
          ExplicitTop = 2
          ExplicitWidth = 661
          ExplicitHeight = 307
          inherited edtUrl: TEdit
            Text = 'http://172.16.200.233:8082/api/cr/callrecord/runpu/ori/update'
          end
          inherited Button2: TButton
            OnClick = frameUrlParam3Button2Click
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'update strs'
        ImageIndex = 3
        inline frameUrlParam4: TframeUrlParam
          Left = 8
          Top = 2
          Width = 661
          Height = 309
          TabOrder = 0
          ExplicitLeft = 8
          ExplicitTop = 2
          ExplicitWidth = 661
          ExplicitHeight = 309
          inherited edtUrl: TEdit
            Text = 'http://172.16.200.233:8082/api/cr/callrecord/runpu/ori/update/1'
          end
          inherited Button2: TButton
            OnClick = frameUrlParam4Button2Click
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'addCookie'
        ImageIndex = 4
        object Label6: TLabel
          Left = 9
          Top = 3
          Width = 30
          Height = 13
          Caption = 'cookie'
        end
        object memoCookie: TMemo
          Left = 24
          Top = 22
          Width = 625
          Height = 24
          Lines.Strings = (
            
              'ACCESS_TICKET="TGT-171-O42vP4LGehJ3z3VGOXPteuccJWdxBvSDTa1bUlSX1' +
              'VT2miqnKM-cas.ecarpo.com"')
          TabOrder = 0
        end
        object Button7: TButton
          Left = 566
          Top = 52
          Width = 75
          Height = 25
          Caption = 'add cookie'
          TabOrder = 1
          OnClick = Button7Click
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'uploadFile'
        ImageIndex = 5
        inline frameUrlParam5: TframeUrlParam
          Left = 8
          Top = 3
          Width = 661
          Height = 303
          TabOrder = 0
          ExplicitLeft = 8
          ExplicitTop = 3
          ExplicitWidth = 661
          ExplicitHeight = 303
          inherited memoCtx: TMemo
            Lines.Strings = (
              'd:\1.txt')
          end
          inherited edtUrl: TEdit
            Text = 'http://172.16.200.233:38081/api/file/upload/1'
          end
          inherited Button2: TButton
            OnClick = frameUrlParam5Button2Click
          end
        end
      end
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 424
    Top = 312
  end
  object NetHTTPRequest1: TNetHTTPRequest
    Asynchronous = False
    ConnectionTimeout = 0
    ResponseTimeout = 0
    Left = 280
    Top = 312
  end
end
