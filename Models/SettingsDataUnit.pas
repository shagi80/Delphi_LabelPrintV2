unit SettingsDataUnit;

interface

const
  bcEAN13 = 1;
  bcCODE128A = 2;

type
  TSettingsData = class(TObject)
  private
    FFileName: string;
    FDefFactoryId: integer;
    FDefShiftId: integer;
    FDefPrinterName: string;
    FDefCount: integer;
    FStorageSize: integer;
    FDefBarCode: integer;
    FCanEditPrintForm: boolean;
    FDontChangeFactory: boolean;
    FBarCodeLeft: integer;
    FBarCodeZoom: real;
    function LoadFromFile: boolean;
  public
    constructor Create(FileName: string);
    property DefFactoryId: integer read FDefFactoryId write FDefFactoryId;
    property DefShiftId: integer read FDefShiftId write FDefShiftId;
    property DefPrinterName: string read FDefPrinterName write FDefPrinterName;
    property DefCount: integer read FDefCount write FDefCount;
    property DefStorageSize: integer read FStorageSize write FStorageSize;
    property DefBarCode: integer reaD FDefBarCode write FDefBarCode;
    property CanEditPrintForm: boolean read FCanEditPrintForm write FCanEditPrintForm;
    property DontChangeFactory: boolean read FDontChangeFactory write FDontChangeFactory;
    property BarCodeLeft: integer read FBarCodeLeft write FBarCodeLeft;
    property BarCodeZoom: real read FBarCodeZoom write FBarCodeZoom;
    procedure SaveToFile;
  end;

implementation

uses
  SysUtils;

type
  TSettingsDataRec = record
    DefFactoryId: integer;
    DefShiftId: integer;
    DefPrinterName: string[255];
    DefCount: integer;
    StorageSize: integer;
    DefBarCode: integer;
    CanEditPrintForm: boolean;
    DontChangeFactory: boolean;
    BarCodeLeft: integer;
    BarCodeZoom: real;
  end;

constructor TSettingsData.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  if not Self.LoadFromFile then begin
    FDefFactoryId := 1;
    FDefShiftId := 1;
    FDefPrinterName := '';
    FDefCount := 100;
    FStorageSize := 5;
    FDefBarCode := bcEAN13;
    FCanEditPrintForm := True;
    FDontChangeFactory := True;
    FBarCodeLeft := 0;
    FBarCodeZoom := 1;
  end;
end;

function TSettingsData.LoadFromFile: boolean;
var
  AFile: file of TSettingsDataRec;
  Rec: TSettingsDataRec;
begin
  Result := False;
  if not FileExists(Self.FFileName) then Exit;
  AssignFile(AFile, Self.FFileName);
  Reset(AFile);
  try
    Read(AFile, Rec);
    FDefFactoryId := Rec.DefFactoryId;
    FDefShiftId := Rec.DefShiftId;
    FDefPrinterName := Rec.DefPrinterName;
    FDefCount := Rec.DefCount;
    FStorageSize := Rec.StorageSize;
    FDefBarCode := Rec.DefBarCode;
    FCanEditPrintForm := Rec.CanEditPrintForm;
    FDontChangeFactory := Rec.DontChangeFactory;
    FBarCodeLeft := Rec.BarCodeLeft;
    FBarCodeZoom := Rec.BarCodeZoom;
    Result := True
  finally
    CloseFile(AFile);
  end;
end;

procedure TSettingsData.SaveToFile;
var
  AFile: file of TSettingsDataRec;
  Rec: TSettingsDataRec;
begin
  if Length(Self.FFileName) = 0 then Exit;
  Rec.DefFactoryId := FDefFactoryId;
  Rec.DefShiftId := FDefShiftId;
  Rec.DefPrinterName := FDefPrinterName;
  Rec.DefCount := FDefCount;
  Rec.StorageSize := FStorageSize;
  Rec.DefBarCode := FDefBarCode;
  Rec.CanEditPrintForm := FCanEditPrintForm;
  Rec.DontChangeFactory := FDontChangeFactory;
  Rec.BarCodeLeft := FBarCodeLeft;
  Rec.BarCodeZoom := FBarCodeZoom;
  AssignFile(AFile, Self.FFileName);
  Rewrite(AFile);
  try
    Write(AFile, Rec)
  finally
    CloseFile(AFile);
  end;
end;

end.
