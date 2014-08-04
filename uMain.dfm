object frm_Main: Tfrm_Main
  Left = 0
  Top = 0
  Caption = 'JavaClassToDelphiUnit'
  ClientHeight = 447
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 656
    Top = 0
    Width = 90
    Height = 447
    Align = alRight
    TabOrder = 0
    object btn1: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Caption = #27979#35797#36716#25442
      TabOrder = 0
      OnClick = btn1Click
    end
  end
  object mmo1: TMemo
    Left = 0
    Top = 0
    Width = 656
    Height = 447
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
