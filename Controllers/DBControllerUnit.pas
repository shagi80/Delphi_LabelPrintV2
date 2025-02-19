unit DBControllerUnit;

interface

uses
  SysUtils, DataStorageUnit, DataListUnit, LabelDataUnit, SQLiteTable3, JPEG;

type
  TDBController = class(TObject)
  private
    FDB : TSQLiteDatabase;
    const DB_FILENAME: string = 'label_data.db';
    function GetMainData(Table: TSQLIteTable;
      DataItem: TLabelData): boolean;
    function LoadFactory(List: TFactoryList): integer;
    function LoadProduct(List: TProductList): integer;
    function LoadModel(List: TModelList): integer;
    function LoadShift(List: TShiftList): integer;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadtData(Storage: TDataStorage): boolean;
    procedure SavePrintForm(ProductId: integer; PrintForm: string);
  end;


implementation

uses
  Classes, Graphics, Dialogs;

constructor TDBController.Create;
begin
  inherited Create;
  if FileExists(DB_FILENAME) then begin
    try
      FDB := TSQLiteDatabase.Create(DB_FILENAME);
    except
      FDB := nil;
    end;
  end;
end;

destructor TDBController.Destroy;
begin
  FDB.Free;
  inherited Destroy;
end;

function TDBController.GetMainData(Table: TSQLIteTable;
  DataItem: TLabelData): boolean;
begin
  try
    DataItem.ID := Table.FieldAsInteger(0);
    DataItem.Title := UTF8Decode(Table.FieldAsString(1));
    DataItem.PrintTitleFull :=  UTF8Decode(Table.FieldAsString(2));
    DataItem.PrintTitleShort := UTF8Decode(Table.FieldAsString(3));
    DataItem.CodeString := UTF8Decode(Table.FieldAsString(4));
    DataItem.CodeNumber := Table.FieldAsInteger(5);
    Result := True;
  except
    Result := False;
  end;
end;

function TDBController.LoadFactory(List: TFactoryList): integer;
var
  Factory: TFactoryData;
  Table: TSQLIteTable;
begin
  Result := 0;
  Table := FDB.GetTable('SELECT * FROM factory ORDER BY title');
  if Table.Count = 0 then Exit;
  Factory := nil;
  try
    while not Table.EOF do begin
      Factory := TFActoryData.Create;
      if not GetMainData(Table, Factory) then
        raise Exception.Create('Can not read main data for facory!');
      Factory.Addr := UTF8Decode(Table.FieldAsString(6));
      Factory.Phone := UTF8Decode(Table.FieldAsString(7));
      Factory.Email := UTF8Decode(Table.FieldAsString(8));
      Factory.Site := UTF8Decode(Table.FieldAsString(9));
      List.Add(Factory);
      Table.Next;
    end;
    Result := 1;
  except
    Factory.Free;
  end;
  Table.Free;
end;

function TDBController.LoadProduct(List: TProductList): integer;
var
  Table: TSQLIteTable;
  Product: TProductData;
  Strm: TMemoryStream;
begin
  Result := 0;
  Table := FDB.GetTable('SELECT * FROM product ORDER BY title');
  if Table.Count = 0 then Exit;
  Product := nil;
  try
    while not Table.EOF do begin
      Product := TProductData.Create;
      if not GetMainData(Table, Product) then
        raise Exception.Create('Can not read main data product !');
      Product.DefPrintFormFile := UTF8Decode(Table.FieldAsString(6));
      Strm := Table.FieldAsBlob(7);
      if Strm <> nil then begin
        if Product.BitMap = nil then Product.BitMap := TBitMap.Create;
        Strm.Position := 0;
        Product.BitMap.LoadFromStream(Strm);
      end;
      Product.TU := UTF8Decode(Table.FieldAsString(8));
      List.Add(Product);
      Table.Next;
    end;
    Result := 1;
  except
    Product.Free;
  end;
  Table.Free;
end;

function TDBController.LoadModel(List: TModelList): integer;
var
  Table: TSQLIteTable;
  Model: TModelData;
begin
  Result := 0;
  Table := FDB.GetTable('SELECT * FROM model ORDER BY title');
  if Table.Count = 0 then Exit;
  Model := nil;
  try
    while not Table.EOF do begin
      Model := TModelData.Create;
      if not GetMainData(Table, Model) then
        raise Exception.Create('Can not read main data for model!');
      Model.GrossWeight := Table.FieldAsDouble(6);
      Model.NetWeight := Table.FieldAsDouble(7);
      Model.Sizes := UTF8Decode(Table.FieldAsString(8));
      Model.PackSizes := UTF8Decode(Table.FieldAsString(9));
      Model.EPower := Table.FieldAsDouble(10);
      Model.EParam := UTF8Decode(Table.FieldAsString(11));
      Model.IPClass := UTF8Decode(Table.FieldAsString(12));
      Model.GroundingClass := UTF8Decode(Table.FieldAsString(13));
      Model.ProductID := Table.FieldAsInteger(14);
      List.Add(Model);
      Table.Next;
    end;
    Result := 1;
  except
    Model.Free;
  end;
  Table.Free;
end;

function TDBController.LoadShift(List: TShiftList): integer;
var
  Table: TSQLIteTable;
  Shift: TShiftData;
begin
  Result := 0;
  Table := FDB.GetTable('SELECT * FROM shift ORDER BY title');
  if Table.Count = 0 then Exit;
  Shift := nil;
  try
    while not Table.EOF do begin
      Shift := TShiftData.Create;
      if not GetMainData(Table, Shift) then
        raise Exception.Create('Can not read main data for shift!');
      List.Add(Shift);
      Table.Next;
    end;
    Result := 1;
  except
    Shift.Free;
  end;
  Table.Free;
end;

function TDBController.LoadtData(Storage: TDataStorage): boolean;
begin
  Result := False;
  if FDB = nil then Exit;
  Storage.Free;
  Storage := TDataStorage.Create;
  Result := (LoadFactory(Storage.FactroyList) * LoadProduct(Storage.ProductList)
    * LoadModel(Storage.ModelList) * LoadShift(Storage.ShiftList)) > 0;
end;

procedure TDBController.SavePrintForm(ProductId: integer; PrintForm: string);
var
  SQL: string;
begin
  if FDB = nil then Exit;
  //begin a transaction
  FDB.BeginTransaction;
  SQL := 'UPDATE product SET def_form_filr = "' + PrintForm
    + '" WHERE id = ' + IntToStr(ProductId);
  FDB.ExecSQL(SQL);
  FDB.Commit;
end;

end.
