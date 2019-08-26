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
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'phone'
      ImageIndex = 2
      inline frameMemoLogD: TframeMemo
        Left = 0
        Top = 0
        Width = 507
        Height = 483
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 507
        ExplicitHeight = 483
        inherited memoMsg: TMemo
          Width = 507
          Height = 483
          ExplicitWidth = 507
          ExplicitHeight = 483
        end
      end
    end
    object StatPage: TTabSheet
      Caption = 'log'
      inline frameMemoLog: TframeMemo
        Left = 0
        Top = 0
        Width = 507
        Height = 483
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 507
        ExplicitHeight = 483
        inherited memoMsg: TMemo
          Width = 507
          Height = 483
          ExplicitWidth = 507
          ExplicitHeight = 483
        end
      end
    end
    object PropPage: TTabSheet
      Caption = 'response'
      inline frameMemoQueue: TframeMemo
        Left = 0
        Top = 0
        Width = 507
        Height = 483
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 507
        ExplicitHeight = 483
        inherited memoMsg: TMemo
          Width = 507
          Height = 483
          ExplicitWidth = 507
          ExplicitHeight = 483
        end
      end
    end
  end
end
