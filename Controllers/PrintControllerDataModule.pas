unit PrintControllerDataModule;

interface

uses
  SysUtils, Classes, frxClass, PrintTaskUnit, frxBarcode,
  SettingsDataUnit;

type
  TdmPrint = class(TDataModule)
    frxReport: TfrxReport;
    frxUserDataSet: TfrxUserDataSet;
    frxBarCodeObject: TfrxBarCodeObject;
    procedure DataModuleCreate(Sender: TObject);
    procedure frxReportGetValue(const VarName: string; var Value: Variant);
  private
    { Private declarations }
    FTask: TPrintTask;
    FFormPath: string;
    FSettings: TSettingsData;
    function PrepareReport(Task: TPrintTask): boolean;
    function SetPrinter: boolean;
    function GetEAN13(Num: integer): string;
    function GetCODE128(Num: integer): string;
  public
    { Public declarations }
    property FormPath: string read FFormPath write FFormPath;
    procedure Preview(Task: TPrintTask; Settings: TSettingsData);
    function Print(Task: TPrintTask; Settings: TSettingsData): boolean;
  end;

var
  dmPrint: TdmPrint;

implementation

{$R *.dfm}

uses
  Dialogs, Forms, frxPrinter, Controls, ConfirmPrinterForm,
  frxBarcod;

procedure TdmPrint.DataModuleCreate(Sender: TObject);
begin
  FTask := nil;
  FSettings := nil;
end;

function TdmPrint.PrepareReport(Task: TPrintTask): boolean;
var
  FileName: string;
  frxBarCode: TfrxBarCodeView;
  frxPage: TfrxReportPage;
begin
  Result := False;
  FileName := FFormPath + Task.PrintForm;
  frxReport.Preview.Visible := FileExists(FileName);
  if not frxReport.Preview.Visible then Exit;
  frxReport.LoadFromFile(FileName);
  frxUserDataSet.First;
  FTask := Task;
  frxBarCode := TfrxBarCodeView(frxReport.FindObject('BarCode'));
  frxPage := TfrxReportPage(frxReport.FindObject('Page'));
  if (frxPage <> nil) and (frxBarCode <> nil) then begin
    frxBarCode.Zoom := FSettings.BarCodeZoom;
    frxBarCode.Left := frxBarCode.Left + FSettings.BarCodeLeft;
    case FSettings.DefBarCode of
      SettingsDataUnit.bcEAN13: begin
        frxBarCode.BarType := bcCodeEAN13;
        frxBarCode.CalcCheckSum := True;
        //frxBarCode.Zoom := 2;
      end;
      SettingsDataUnit.bcCODE128A: begin
        frxBarCode.BarType := bcCode128A;
        frxBarCode.CalcCheckSum := False;
        //frxBarCode.Zoom := 1.1;
        //frxBarCode.Left := frxBarCode.Left - 10;
      end;
    end;
  end;
  //frxBarCode.Left := frxBarCode.Left + FSettings.BarCodeLeft;
  Result := True;
end;

function TdmPrint.GetEAN13(Num: integer): string;
begin
  Result := FormatFloat('00', FTask.Model.CodeNumber)
    + FormatDateTime('ddmmyy', FTask.Date)
    + FormatFloat('0', FTask.Shift.CodeNumber)
    + FormatFloat('000', Num);
end;

function TdmPrint.GetCODE128(Num: integer): string;
begin
  Result := FTask.Factory.CodeString + FTask.Product.CodeString
    + FTask.Model.CodeString + FormatDateTime('ddmmyy', FTask.Date)
    + FTask.Shift.CodeString + FormatFloat('000', Num);
end;


procedure TdmPrint.frxReportGetValue(const VarName: string; var Value: Variant);
var
  Num: integer;
begin
  value:='0';
  if CompareText(VarName, 'product') = 0 then value := FTask.Product.PrintTitleFull;
  if CompareText(VarName, 'model') = 0 then value := FTask.Model.PrintTitleFull;
  if CompareText(VarName, 'power') = 0 then value :=
    FormatFloat('#0.00', FTask.Model.EPower) + ' Âò';
  if CompareText(VarName, 'net') = 0 then value :=
    FormatFloat('#0.00', FTask.Model.GrossWeight) + ' êã';
  if CompareText(VarName, 'mydate') = 0 then value :=
    FormatDateTime('dd.mm.yy', FTask.Date);
  Num := frxUserDataSet.RecordCount - frxUserDataSet.RecNo + FTask.First - 1;
  if CompareText(VarName,'sn') = 0 then
    value := FTask.Factory.CodeString + FTask.Model.CodeString
      + FormatDateTime('ddmmyy', FTask.Date) + FTask.Shift.CodeString
      + FormatFloat('000', Num);
  if CompareText(VarName, 'eparam') = 0 then
    value := FTask.Model.EParam + '   ' + FTask.Model.IPClass
      + '   ' + FTask.Model.GroundingClass;
  if CompareText(VarName, 'factory') = 0 then
    value := 'ÈÇÃÎÒÎÂÈÒÅËÜ ' + FTask.Factory.PrintTitleShort
      + ' ' + FTask.Product.TU;
  if CompareText(VarName,'CODE') = 0 then
    case FSettings.DefBarCode of
      SettingsDataUnit.bcEAN13: value := Self.GetEAN13(Num);
      SettingsDataUnit.bcCODE128A: value := Self.GetCODE128(Num);
    end;
end;


procedure TdmPrint.Preview(Task: TPrintTask; Settings: TSettingsData);
begin
  FSettings := Settings;
  if not Self.PrepareReport(Task) then Exit;
  frxUserDataSet.RangeEndCount := 1;
  frxReport.PrepareReport(True);
  FTask := nil;
end;


function TdmPrint.SetPrinter: boolean;
var
  Ind: integer;
  Name: string;
begin
  Result := False;
  if Length(FTask.Printer) > 0 then Name := FTask.Printer
    else Name := FSettings.DefPrinterName;
  if Length(Name) = 0 then Exit;
  Ind := frxPrinters.IndexOf(Name);
  if Ind >= 0 then begin
    frxPrinters.PrinterIndex := Ind;
    frxReport.PrintOptions.Printer := frxPrinters[Ind].Name;
    Result := True;
  end;
end;

function TdmPrint.Print(Task: TPrintTask; Settings: TSettingsData): boolean;
begin
  Result := False;
  FSettings := Settings;
  if not Self.PrepareReport(Task) then Exit;
  frxReport.PrintOptions.ShowDialog := True;
  if Self.SetPrinter then
    case frmConfirmPrinter.Confirm(FTask.Printer) of
      mrCancel: begin
          Ftask := nil;
          Exit;
        end;
      mrYes: frxReport.PrintOptions.ShowDialog := False;
    end;
  frxUserDataSet.RangeEndCount := FTask.Count;
  frxReport.Preview.Visible := False;
  frxReport.PrepareReport(True);
  try
    Result := frxReport.Print;
    if Result then Task.Printer := frxPrinters.Printer.Name;
  finally
    frxUserDataSet.RangeEndCount := 1;
    frxReport.PrepareReport(True);
    frxReport.Preview.Visible := True;;
    FTask := nil;
  end;
end;

end.
