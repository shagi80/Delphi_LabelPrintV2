unit LabelDataUnit;

interface

uses
  Graphics;

type
  TLabelData = class(TObject)
  private
    FID: integer;
    FTitle: string;
    FPrintTitleFull: string;
    FPrintTitleShort: string;
    FCodeString: string;
    FCodeNumber: integer;
  public
    property ID: integer read FID write FID;
    property Title: string read FTitle write FTitle;
    property PrintTitleFull: string read FPrintTitleFull write FPrintTitleFull;
    property PrintTitleShort: string read FPrintTitleShort write FPrintTitleShort;
    property CodeString: string read FCodeString write FCodeString;
    property CodeNumber: integer read FCodeNumber write FCodeNumber;
  end;

  TFactoryData = class(TLabelData)
  private
    FAddr: string;
    FPhone: string;
    FEmail: string;
    FSite: string;
  public
    property Addr: string read FAddr write FAddr;
    property Phone: string read FPhone write FPhone;
    property Email: string read FEmail write FEmail;
    property Site: string read FSite write FSite;
  end;

  TProductData = class(TLabelData)
  private
    FBitMap: TBitMap;
    FDefPrintFormFile: string;
    FTu: string;
    procedure SetBitMap(Source: TBitMap);
  public
    constructor Create;
    destructor Destroy; override;
    property BitMap: TBitMap read FBitMap write SetBitMap;
    property DefPrintFormFile: string read FDefPrintFormFile write FDefPrintFormFile;
    property TU: string read FTu write FTu;
  end;

  TShiftData = class(TLabelData)
  end;

  TModelData = class(TLabelData)
  private
    FGrossWeight: real;
    FNetWeight: real;
    FSizes: string;
    FPackSizes: string;
    FEPower: real;
    FEParam: string;
    FIPClass: string;
    FGroundingClass: string;
    FProductID: integer;
  public
    property GrossWeight: real read FGrossWeight write FGrossWeight;
    property NetWeight: real read FNetWeight write FNetWeight;
    property Sizes: string read FSizes write FSizes;
    property PackSizes: string read FPackSizes write FPackSizes;
    property EPower: real read FEPower write FEPower;
    property EParam: string read FEParam write FEParam;
    property IPClass: string read FIPClass write FIPClass;
    property GroundingClass: string read FGroundingClass write FGroundingClass;
    property ProductID: integer read FProductID write FProductID;
  end;

implementation


constructor TProductData.Create;
begin
  inherited Create;
  FBitMap := nil;
end;

destructor TProductData.Destroy;
begin
  FBitMap.Free;
  inherited Destroy;
end;

procedure TProductData.SetBitMap(Source: TBitMap);
begin
  if FBitMap <> nil then FBitMap.Free;
  FBitMap := TBitMap.Create;
  FBitMap.Assign(Source);
end;

end.
