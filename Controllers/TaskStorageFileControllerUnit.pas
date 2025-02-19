unit TaskStorageFileControllerUnit;

interface

uses
  TaskStorageControl, DataStorageUnit, LabelDataUnit, Contnrs;

type
  TTaskStorageFileController = class(TObject)
  private
    FFileName: string;
    function SetLabelData(Id: integer; var LabelData: TLabelData;
      List: TObjectList): boolean;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    procedure Save(StoragePanel: TStoragePanel);
    function Load(StoragePanel: TStoragePanel; DataStorage: TDataStorage): boolean;
  end;

implementation

uses
  SysUtils, Classes, PrintTaskUnit, Dialogs;

type
  TTaskRec = record
    FactoryId: integer;
    ProductId: integer;
    ModelId: integer;
    ShiftId: integer;
    First: integer;
    Count: integer;
    PrintForm: string[255];
    Printer: string[255];
    Date: TDateTime;
  end;

constructor TTaskStorageFileController.Create(FileName: string);
begin
  inherited Create;
  FFileName := FileName;
end;

destructor TTaskStorageFileController.Destroy;
begin
  inherited Destroy;
end;

function TTaskStorageFileController.SetLabelData(Id: integer; var LabelData:
  TLabelData; List: TObjectList): boolean;
var
  I: integer;
begin
  Result := False;
  for I := 0 to List.Count - 1 do
    if TLabelData(List[I]).ID = Id then begin
      LabelData := TLabelData(List[I]);
      Result := True;
      Exit;
    end;
end;

procedure TTaskStorageFileController.Save(StoragePanel: TStoragePanel);
var
  I: integer;
  Rec: TTaskRec;
  AFile: File of TTaskRec;
  Task: TPrintTask;
begin
  Assign(AFile, Self.FFileName);
  Rewrite(AFile);
  try
    for I := 0 to StoragePanel.ControlCount - 1 do begin
      Task := TStorageItem(StoragePanel.Controls[I]).Task;
      Rec.FactoryId := Task.Factory.id;
      Rec.ProductId := Task.Product.ID;
      Rec.ModelId := Task.Model.ID;
      Rec.ShiftId := Task.Shift.ID;
      Rec.First := Task.First;
      Rec.Count := Task.Count;
      Rec.PrintForm := Task.PrintForm;
      Rec.Printer := Task.Printer;
      Rec.Date := Task.Date;
      Write(AFile, Rec);
    end;
  finally
    CloseFile(AFile);
  end;
end;

function TTaskStorageFileController.Load(StoragePanel: TStoragePanel;
  DataStorage: TDataStorage): boolean;
var
  Rec: TTaskRec;
  AFile: File of TTaskRec;
  Task: TPrintTask;
  LabelData: TLabelData;
begin
  Result := False;
  if not FileExists(Self.FFileName) then Exit;  
  Assign(AFile, Self.FFileName);
  Reset(AFile);
  while not EoF(AFile) do begin
    Read(AFile, Rec);
    Task := TPrintTask.Create;
    try
      if not Self.SetLabelData(Rec.FactoryId, LabelData,
        DataStorage.FactroyList) then
          raise Exception.Create('Error load storage!');
      Task.Factory := TFactoryData(LabelData);
      if not Self.SetLabelData(Rec.ProductId, LabelData,
        DataStorage.ProductList) then
          raise Exception.Create('Error load storage!');
      Task.Product := TProductData(LabelData);
      if not Self.SetLabelData(Rec.ModelId, LabelData,
        DataStorage.ModelList) then
          raise Exception.Create('Error load storage!');
      Task.Model := TModelData(LabelData);
      if not Self.SetLabelData(Rec.ShiftId, LabelData,
        DataStorage.ShiftList) then
          raise Exception.Create('Error load storage!');
      Task.Shift := TShiftData(LabelData);
      Task.First := Rec.First;
      Task.Count := Rec.Count;
      Task.PrintForm := Rec.PrintForm;
      Task.Printer := Rec.Printer;
      Task.Date := Rec.Date;
      StoragePanel.AddItem(Task);
    except
      Task.Free;
      CloseFile(AFile);
      Exit;
    end;
  end;
  CloseFile(AFile);
  Result := True;
end;

end.
