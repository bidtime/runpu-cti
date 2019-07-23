object frameUrlParam: TframeUrlParam
  Left = 0
  Top = 0
  Width = 598
  Height = 298
  TabOrder = 0
  object Label11: TLabel
    Left = 6
    Top = 6
    Width = 35
    Height = 13
    Caption = 'http url'
  end
  object Label12: TLabel
    Left = 6
    Top = 29
    Width = 30
    Height = 13
    Caption = 'param'
  end
  object memoCtx: TMemo
    Left = 56
    Top = 31
    Width = 449
    Height = 258
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtUrl: TEdit
    Left = 56
    Top = 4
    Width = 449
    Height = 21
    TabOrder = 1
    Text = 'http://172.16.200.225:8081/api/cr/callrecord/runpu/ori/'
  end
  object Button2: TButton
    Left = 511
    Top = 3
    Width = 75
    Height = 25
    Caption = 'post'
    TabOrder = 2
  end
end
