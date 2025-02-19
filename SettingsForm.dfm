object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 378
  ClientWidth = 359
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
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 359
    Height = 329
    Align = alTop
    BorderWidth = 10
    TabOrder = 0
    object Label6: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 14
      Width = 334
      Height = 13
      Margins.Left = 0
      Margins.Bottom = 15
      Align = alTop
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ExplicitWidth = 129
    end
    object pnGrid: TGridPanel
      Left = 11
      Top = 42
      Width = 337
      Height = 271
      Align = alTop
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 41.520467836257310000
        end
        item
          Value = 58.479532163742690000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Label1
          Row = 0
        end
        item
          Column = 0
          Control = Label2
          Row = 1
        end
        item
          Column = 0
          Control = Label3
          Row = 2
        end
        item
          Column = 0
          Control = Label4
          Row = 3
        end
        item
          Column = 1
          Control = edHistorySize
          Row = 3
        end
        item
          Column = 0
          Control = Label5
          Row = 4
        end
        item
          Column = 1
          Control = cbFactory
          Row = 0
        end
        item
          Column = 1
          Control = cbShift
          Row = 1
        end
        item
          Column = 1
          Control = edCount
          Row = 2
        end
        item
          Column = 1
          Control = cbPrinter
          Row = 4
        end
        item
          Column = 0
          Control = Label7
          Row = 5
        end
        item
          Column = 1
          Control = cbBarCode
          Row = 5
        end
        item
          Column = 0
          Control = Label8
          Row = 6
        end
        item
          Column = 1
          Control = cbCanEditPrintForm
          Row = 6
        end
        item
          Column = 0
          Control = Label9
          Row = 7
        end
        item
          Column = 1
          Control = cbChangeFactory
          Row = 7
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 35.000000000000000000
        end>
      TabOrder = 0
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 79
        Height = 29
        Align = alLeft
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        ExplicitHeight = 13
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 38
        Width = 31
        Height = 29
        Align = alLeft
        Caption = #1057#1084#1077#1085#1072
        ExplicitHeight = 13
      end
      object Label3: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 73
        Width = 110
        Height = 29
        Align = alLeft
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1101#1090#1080#1082#1077#1090#1086#1082
        ExplicitHeight = 13
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 108
        Width = 113
        Height = 29
        Align = alLeft
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1080#1089#1090#1086#1088#1080#1080
        ExplicitHeight = 13
      end
      object edHistorySize: TEdit
        Left = 139
        Top = 105
        Width = 60
        Height = 21
        TabOrder = 1
        Text = 'edHistorySize'
        OnKeyPress = edCountKeyPress
      end
      object Label5: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 143
        Width = 43
        Height = 29
        Align = alLeft
        Caption = #1055#1088#1080#1085#1090#1077#1088
        ExplicitHeight = 13
      end
      object cbFactory: TComboBox
        Left = 139
        Top = 0
        Width = 198
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object cbShift: TComboBox
        Left = 139
        Top = 35
        Width = 198
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
      object edCount: TEdit
        Left = 139
        Top = 70
        Width = 60
        Height = 21
        TabOrder = 3
        Text = 'edCount'
        OnKeyPress = edCountKeyPress
      end
      object cbPrinter: TComboBox
        Left = 139
        Top = 140
        Width = 198
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
      end
      object Label7: TLabel
        Left = 0
        Top = 175
        Width = 139
        Height = 13
        Align = alTop
        Caption = #1058#1080#1087' '#1096#1090#1088#1080#1093#1082#1086#1076#1072
        ExplicitWidth = 78
      end
      object cbBarCode: TComboBox
        Left = 139
        Top = 175
        Width = 198
        Height = 21
        Align = alTop
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object Label8: TLabel
        Left = 0
        Top = 210
        Width = 139
        Height = 13
        Align = alTop
        Caption = #1048#1079#1084#1077#1085#1080#1103#1090#1100' '#1092#1086#1088#1084#1091
        ExplicitWidth = 89
      end
      object cbCanEditPrintForm: TCheckBox
        Left = 139
        Top = 210
        Width = 198
        Height = 17
        Align = alTop
        TabOrder = 6
      end
      object Label9: TLabel
        Left = 0
        Top = 245
        Width = 139
        Height = 13
        Align = alTop
        Caption = #1052#1077#1085#1103#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
        ExplicitWidth = 119
      end
      object cbChangeFactory: TCheckBox
        Left = 139
        Top = 245
        Width = 198
        Height = 17
        Align = alTop
        TabOrder = 7
      end
    end
  end
  object btnOk: TBitBtn
    Left = 195
    Top = 340
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 276
    Top = 340
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    Kind = bkCancel
  end
end
