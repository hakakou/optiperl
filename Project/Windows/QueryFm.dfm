object QueryFrame: TQueryFrame
  Left = 0
  Top = 0
  Width = 400
  Height = 300
  AutoScroll = False
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    400
    300)
  object lblManual: TLabel
    Left = 2
    Top = 265
    Width = 34
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Manual'
    FocusControl = edManual
  end
  object vlQuery: TStringGrid
    Left = 0
    Top = 0
    Width = 400
    Height = 260
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 200
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 40
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
    ScrollBars = ssVertical
    TabOrder = 0
    OnKeyDown = vlQueryKeyDown
    OnSetEditText = vlQuerySetEditText
    ColWidths = (
      200
      206)
  end
  object edManual: TEdit
    Left = 0
    Top = 279
    Width = 400
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    OnChange = edManualChange
  end
end
