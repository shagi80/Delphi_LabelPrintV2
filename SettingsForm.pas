unit SettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Contnrs, DataStorageUnit,
  SettingsDataUnit;

type
  TfrmSettings = class(TForm)
    pnMain: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    pnGrid: TGridPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edHistorySize: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    cbFactory: TComboBox;
    cbShift: TComboBox;
    edCount: TEdit;
    cbPrinter: TComboBox;
    Label7: TLabel;
    cbBarCode: TComboBox;
    Label8: TLabel;
    cbCanEditPrintForm: TCheckBox;
    Label9: TLabel;
    cbChangeFactory: TCheckBox;
    Label10: TLabel;
    edBarCodeLeft: TEdit;
    Label11: TLabel;
    edBarCodeZoom: TEdit;
    procedure edBarCodeLeftKeyPress(Sender: TObject; var Key: Char);
    procedure edBarCodeZoomKeyPress(Sender: TObject; var Key: Char);
    procedure edCountKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure UpdateComboBoxFromDataList(Box: TComboBox; Data: TObjectList;
      Id: integer);
    procedure UpdatePrinterList(DefName: string);
    procedure UpdateBarCodeList(Def: integer);
  public
    { Public declarations }
    function EditSettings(DataStorage: TDataStorage;
      SettingsData: TSettingsData): boolean;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  LabelDataUnit, frxPrinter;

procedure TfrmSettings.UpdateComboBoxFromDataList(Box: TComboBox;
  Data: TObjectList; Id: integer);
var
  I, Ind: integer;
begin
  Box.Items.Clear;
  Ind := 0;
  for I := 0 to Data.Count - 1 do begin
    Box.Items.AddObject(TLabelData(Data[I]).Title, Data[I]);
    if TLabelData(Data[I]).ID = Id then Ind := I;
  end;
  if Box.Items.Count > 0 then Box.ItemIndex := Ind;
end;

procedure TfrmSettings.edBarCodeLeftKeyPress(Sender: TObject; var Key: Char);
const
  Toolskey = [13, 8, 38..40, 48..57];
begin
  self.Caption := inttostr(ord(Key));
  if (not(ord(Key) in ToolsKey) and not(Key in ['-'])) then Key := chr(0);
end;

procedure TfrmSettings.edBarCodeZoomKeyPress(Sender: TObject; var Key: Char);
const
  Toolskey = [13, 8, 38..40, 48..57];
begin
  self.Caption := inttostr(ord(Key));
  if (not(ord(Key) in ToolsKey) and not(Key in ['.', ','])) then Key := chr(0);
end;

procedure TfrmSettings.edCountKeyPress(Sender: TObject; var Key: Char);
const
  Toolskey = [13, 8, 38..40, 48..57];
begin
  self.Caption := inttostr(ord(Key));
  if not(ord(Key) in ToolsKey) then Key := chr(0);
end;

procedure TfrmSettings.UpdatePrinterList(DefName: string);
var
  I, Ind: integer;
begin
  cbPrinter.Items.Clear;
  cbPrinter.Items.AddStrings(frxPrinters.Printers);
  Ind := -2;
  for I := 0 to cbPrinter.Items.Count - 1 do
    if cbPrinter.Items.Strings[I] = DefName then begin
      Ind := I;
      Break;
    end;
  cbPrinter.ItemIndex := Ind;
end;

procedure TfrmSettings.UpdateBarCodeList(Def: integer);
begin
  cbBarCode.Items.Clear;
  cbBarCode.Items.Add('EAN13');
  cbBarCode.Items.Add('CODE128A');
  cbBarCode.ItemIndex := Def - 1;
end;

function TfrmSettings.EditSettings(DataStorage: TDataStorage;
  SettingsData: TSettingsData): boolean;
begin
  UpdateComboBoxFromDataList(Self.cbFactory, DataStorage.FactroyList,
    SettingsData.DefFactoryId);
  UpdateComboBoxFromDataList(Self.cbShift, DataStorage.ShiftList,
    SettingsData.DefShiftId);
  edCount.Text := IntToStr(SettingsData.DefCount);
  edHistorySize.Text := IntToStr(SettingsData.DefStorageSize);
  UpdatePrinterList(SettingsData.DefPrinterName);
  UpdateBarCodeList(SettingsData.DefBarCode);
  cbCanEditPrintForm.Checked := SettingsData.CanEditPrintForm;
  cbChangeFactory.Checked := not SettingsData.DontChangeFactory;
  edBarCodeLeft.Text := IntToStr(SettingsData.BarCodeLeft);
  edBarCodeZoom.Text := FloatToStr(SettingsData.BarCodeZoom);

  Result := (Self.ShowModal = mrOk);
  if Result then begin
    if cbFactory.ItemIndex = -1 then SettingsData.DefFactoryId := 0 else
      SettingsData.DefFactoryId := TFactoryData(
        cbFactory.Items.Objects[cbFactory.ItemIndex]).ID;
    if cbShift.ItemIndex = -1 then SettingsData.DefShiftId := 0 else
      SettingsData.DefShiftId := TShiftData(
        cbShift.Items.Objects[cbShift.ItemIndex]).ID;
    SettingsData.DefCount := StrToIntDef(edCount.Text, 1);
    SettingsData.DefStorageSize := StrToIntDef(edHistorySize.Text, 5);
    if cbPrinter.ItemIndex = -1 then SettingsData.DefPrinterName := '' else
      SettingsData.DefPrinterName := cbPrinter.Items.Strings[cbPrinter.ItemIndex];
    SettingsData.DefBarCode := cbBarCode.ItemIndex + 1;
    SettingsData.CanEditPrintForm := cbCanEditPrintForm.Checked;
    SettingsData.DontChangeFactory := not cbChangeFactory.Checked;
    SettingsData.BarCodeLeft := StrToIntDef(edBarCodeLeft.Text, 0);
    SettingsData.BarCodeZoom := StrToFloatDef(edBarCodeZoom.Text, 1);
  end;
end;

end.
