object FrameProp: TFrameProp
  Left = 0
  Top = 0
  Width = 515
  Height = 511
  TabOrder = 0
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 515
    Height = 511
    ActivePage = PropPage
    Align = alClient
    TabOrder = 0
    object PropPage: TTabSheet
      Caption = 'Log info'
      DesignSize = (
        507
        483)
      object PortGroup: TGroupBox
        Left = 8
        Top = 6
        Width = 491
        Height = 471
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        DesignSize = (
          491
          471)
        object memoMsg: TMemo
          Left = 11
          Top = 19
          Width = 468
          Height = 439
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object StatPage: TTabSheet
      Caption = 'Property'
      TabVisible = False
      DesignSize = (
        507
        483)
      object GroupBox1: TGroupBox
        Left = 8
        Top = 6
        Width = 491
        Height = 470
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        DesignSize = (
          491
          470)
        object ValueListEditor1: TValueListEditor
          Left = 9
          Top = 21
          Width = 470
          Height = 410
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          TitleCaptions.Strings = (
            #21517#31216
            #20540
            #38190)
          ColWidths = (
            150
            314)
        end
        object btnApply: TButton
          Left = 322
          Top = 375
          Width = 75
          Height = 25
          Caption = #24212#29992'(&A)'
          TabOrder = 1
        end
        object btnTest: TButton
          Left = 225
          Top = 375
          Width = 75
          Height = 25
          Caption = #27979#35797'(&T)'
          Default = True
          TabOrder = 2
        end
      end
    end
  end
end
