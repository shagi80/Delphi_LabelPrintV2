unit PrintTaskUnit;

interface

uses
  LabelDataUnit;

type
  TPrintTask = class(TObject)
  private
    FFactory: TFactoryData;
    FProduct: TProductData;
    FModel: TModelData;
    FShift: TShiftData;
    FFirst: integer;
    FCount: integer;
    FPrintForm: string;
    FPrinter: string;
    FDate: TDateTime;
    function GetLast: integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Factory: TFactoryData read FFactory write FFactory;
    property Product: TProductData read FProduct write FProduct;
    property Model: TModelData read FModel write FModel;
    property Shift: TShiftData read FShift write FShift;
    property First: integer read FFirst write FFirst;
    property Count: integer read FCount write FCount;
    property PrintForm: string read FPrintForm write FPrintForm;
    property Printer: string read FPrinter write FPrinter;
    property Last: integer read GetLast;
    property Date: TDateTime read FDate write FDate;
    procedure Assign(Task: TPrintTask); overload;
    procedure Assign(Product: TProductData); overload;
  end;

implementation

constructor TPrintTask.Create;
begin
  inherited Create;
  FFactory := nil;
  FProduct := nil;
  FModel := nil;
  FShift := nil;
  FFirst := 0;
  FCount := 0;
  FPrintForm := '';
  FPrinter := '';
end;

destructor TPrintTask.Destroy;
begin
  FFactory := nil;
  FProduct := nil;
  FModel := nil;
  FShift := nil;
  FFirst := 0;
  FCount := 0;
  FPrintForm := '';
  FPrinter := '';
  inherited Destroy;
end;

procedure TPrintTask.Assign(Task: TPrintTask);
begin
  FFactory := Task.Factory;
  FProduct := Task.Product;
  FModel := Task.Model;
  FShift := Task.Shift;
  FFirst := Task.First;
  FCount := Task.Count;
  FPrintForm := Task.PrintForm;
  FPrinter := Task.Printer;
  FDate := Task.Date;
end;

procedure TPrintTask.Assign(Product: TProductData);
begin
  FFactory := nil;
  FProduct := Product;
  FModel := nil;
  FShift := nil;
  FFirst := 1;
  FCount := 10;
  FPrintForm := Product.DefPrintFormFile;
  FPrinter := '';
  FDate := 0;
end;

function TPrintTask.GetLast: integer;
begin
  Result := FFirst + FCount - 1;
end;

end.
