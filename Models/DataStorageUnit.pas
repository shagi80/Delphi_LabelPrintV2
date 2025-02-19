unit DataStorageUnit;

interface

uses
  DataListUnit;

type
  TDataStorage = class(TObject)
  private
    FFactoryList: TFactoryList;
    FProductList: TProductList;
    FModelList: TMOdelList;
    FShiftList: TShiftList;
  public
    constructor Create;
    destructor Destroy; override;
    property FactroyList: TFactoryList read FFactoryList write FFactoryList;
    property ProductList: TProductList read FProductList write FProductList;
    property ModelList: TMOdelList read FModelList write FModelList;
    property ShiftList: TShiftList read FShiftList write FShiftList;
  end;

implementation

constructor TDataStorage.Create;
begin
  inherited Create;
  FFactoryList := TFactoryList.Create;
  FProductList := TProductList.Create;
  FModelList := TModelList.Create;
  FShiftList := TShiftList.Create;
end;

destructor TDataStorage.Destroy;
begin
  FFactoryList.Free;
  FProductList.Free;
  FModelList.Free;
  FShiftList.Free;
  inherited Destroy;
end;

end.
