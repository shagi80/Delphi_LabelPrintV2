unit DataListUnit;

interface

uses
  Contnrs, LabelDataUnit;

type
  TFactoryList = class(TObjectList)
  private
    function GetItem(Index: Integer): TFactoryData;
    procedure SetItem(Index: Integer; Item: TFactoryData);
  public
    function Extract(Item: TObject): TFactoryData;
    function First: TFactoryData;
    function Last: TFactoryData;
    property Items[Index: Integer]: TFactoryData read GetItem write SetItem; default;
  end;

 TProductList = class(TObjectList)
  private
    function GetItem(Index: Integer): TProductData;
    procedure SetItem(Index: Integer; Item: TProductData);
  public
    function Extract(Item: TObject): TProductData;
    function First: TProductData;
    function Last: TProductData;
    property Items[Index: Integer]: TProductData read GetItem write SetItem; default;
  end;

 TModelList = class(TObjectList)
  private
    function GetItem(Index: Integer): TModelData;
    procedure SetItem(Index: Integer; Item: TModelData);
  public
    function Extract(Item: TObject): TModelData;
    function First: TModelData;
    function Last: TModelData;
    property Items[Index: Integer]: TModelData read GetItem write SetItem; default;
  end;

  TShiftList = class(TObjectList)
  private
    function GetItem(Index: Integer): TShiftData;
    procedure SetItem(Index: Integer; Item: TShiftData);
  public
    function Extract(Item: TObject): TShiftData;
    function First: TShiftData;
    function Last: TShiftData;
    property Items[Index: Integer]: TShiftData read GetItem write SetItem; default;
  end;


implementation

// Factory data list

function TFactoryList.GetItem(Index: Integer): TFactoryData;
begin
  Result := TFactoryData(inherited GetItem(Index));
end;

procedure TFactoryList.SetItem(Index: Integer; Item: TFactoryData);
begin
  inherited SetItem(Index, Item);
end;

function TFactoryList.Extract(Item: TObject): TFactoryData;
begin
  Result := TFactoryData(inherited Extract(Item));
end;

function TFactoryList.First: TFactoryData;
begin
  Result := TFactoryData(inherited First);
end;

function TFactoryList.Last: TFactoryData;
begin
  Result := TFactoryData(inherited Last);
end;

// Product data list

function TProductList.GetItem(Index: Integer): TProductData;
begin
  Result := TProductData(inherited GetItem(Index));
end;

procedure TProductList.SetItem(Index: Integer; Item: TProductData);
begin
  inherited SetItem(Index, Item);
end;

function TProductList.Extract(Item: TObject): TProductData;
begin
  Result := TProductData(inherited Extract(Item));
end;

function TProductList.First: TProductData;
begin
  Result := TProductData(inherited First);
end;

function TProductList.Last: TProductData;
begin
  Result := TProductData(inherited Last);
end;

// Model data list

function TModelList.GetItem(Index: Integer): TModelData;
begin
  Result := TModelData(inherited GetItem(Index));
end;

procedure TModelList.SetItem(Index: Integer; Item: TModelData);
begin
  inherited SetItem(Index, Item);
end;

function TModelList.Extract(Item: TObject): TModelData;
begin
  Result := TModelData(inherited Extract(Item));
end;

function TModelList.First: TModelData;
begin
  Result := TModelData(inherited First);
end;

function TModelList.Last: TModelData;
begin
  Result := TModelData(inherited Last);
end;

// Shift data list

function TShiftList.GetItem(Index: Integer): TShiftData;
begin
  Result := TShiftData(inherited GetItem(Index));
end;

procedure TShiftList.SetItem(Index: Integer; Item: TShiftData);
begin
  inherited SetItem(Index, Item);
end;

function TShiftList.Extract(Item: TObject): TShiftData;
begin
  Result := TShiftData(inherited Extract(Item));
end;

function TShiftList.First: TShiftData;
begin
  Result := TShiftData(inherited First);
end;

function TShiftList.Last: TShiftData;
begin
  Result := TShiftData(inherited Last);
end;


end.
