unit TaskStorageControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, PrintTaskUnit;

type
  TStorageItem = class(TPanel)
  private
    FCardCaption: string;
    FCaptionFont: TFont;
    FRowCount: integer;
    FRowFont: TFont;
    FRowMargin: integer;
    FImageWidth: integer;
    FIconBitMap: TBitMap;
    FBorderWidth: integer;
    FStretchWidth: boolean;
    FStretchHeight: boolean;
    FRows: TStringList;
    FTask: TPrintTask;
    procedure SetIconBitMap(Source: TBitMap);
    procedure MouseEnter(Sender: TObject);
    procedure MouseLeave(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CardCaption: string read FCardCaption write FCardCaption;
    property CaptionFont: TFont read FCaptionFont write FCaptionFont;
    property RowCount: integer read FRowCount write FRowCount;
    property RowMargin: integer read FRowMargin write FRowMargin;
    property ImageWidth: integer read FImageWidth write FImageWidth;
    property IconBitMap: TBitMap read FIconBitMap write SetIconBitMap;
    property BorderWidth: integer read FBorderWidth write FBorderWidth;
    property StretchWidth: boolean read FStretchWidth write FStretchWidth;
    property StretchHeight: boolean read FStretchHeight write FStretchHeight;
    property Rows: TStringList read FRows write FRows;
    property Task: TPrintTask read FTask;
    procedure AssignTask(Task: TPrintTask);
  end;

  TOnSelectItem = procedure (Sender: TOBject) of object;

  TStoragePanel = class(TPanel)
  private
    FStorageSize: integer;
    FItemWidth: integer;
    FItemSpace: integer;
    FOnSelectItem: TOnSelectItem;
    FDefItemBitMap: TBitMap;
    function GetItem(Ind: integer): TStorageItem;
    procedure SetStorageSize(Size: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property StorageSize: integer read FStorageSize write SetStorageSize;
    property ItemWidth: integer read FItemWidth write FItemWidth;
    property ItemSpace: integer read FItemSpace write FItemSpace;
    property Items[Ind: integer]: TStorageItem read GetItem;
    property OnSelectItem: TOnSelectItem read FOnSelectItem write FOnSelectItem;
    property DefItemBitMap: TBitMap read FDefItemBitMap write FDefItemBitMap;
    procedure AddItem(Task: TPrintTask);
    procedure Clear;
  end;


procedure CopyBitMap(Target, Source: TBitMap);


implementation


// Процедура компрования изображений с изменение размера

procedure CopyBitMap(Target, Source: TBitMap);
var
  L: integer;
  K: real;
  Rct: TRect;
begin
  Rct := Target.Canvas.ClipRect;
  K := (Source.Canvas.ClipRect.Right - Source.Canvas.ClipRect.Left)
    / (Source.Canvas.ClipRect.Bottom - Source.Canvas.ClipRect.Top);
  if K > 1 then begin
    Rct.Bottom := trunc(Target.Height * 1 / K);
  end else begin
    L := trunc(Target.Width * (1 - K) / 2);
    Rct.Left := Rct.Left + L;
    Rct.Right := Rct.Right - L;
  end;
  Target.Canvas.CopyRect(Rct, Source.Canvas, Source.Canvas.ClipRect);
end;

// TStoragePanel

constructor TStoragePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStorageSize := 5;
  FItemWidth := 250;
  FItemSpace := 5;
  Self.BevelOuter := bvNone;
  Self.Height := 100;
  Self.Color := clWhite;
  Self.Visible := False;
end;

destructor TStoragePanel.Destroy;
begin
  Self.SetStorageSize(0);
  inherited Destroy;
end;

procedure TStoragePanel.AddItem(Task: TPrintTask);
var
  Item: TStorageItem;
begin
  Self.Visible := True;
  Item := TStorageItem.Create(Self);
  Item.Width := FItemWidth;
  Item.AlignWithMargins := True;
  Item.Margins.Top := 0;
  Item.Margins.Bottom := 0;
  Item.Margins.Left := 0;
  Item.Margins.Right := ItemSpace;
  Item.AssignTask(Task);
  Item.Align := alLeft;
  Item.OnClick := Self.FOnSelectItem;
  Self.InsertControl(Item);
  if Self.ControlCount > Self.FStorageSize then Self.Controls[0].Free;
  Self.Width := Self.ControlCount * (Self.FItemWidth + FItemSpace) - FItemSpace;
end;

function TStoragePanel.GetItem(Ind: integer): TStorageItem;
begin
  if Ind >= Self.ControlCount then Result := nil
    else Result := TStorageItem(Self.Controls[Ind]);
end;

procedure TStoragePanel.Clear;
begin
  while Self.ControlCount > 0 do Self.Controls[0].Free;
  Self.Visible := False;
end;

procedure TStoragePanel.SetStorageSize(Size: integer);
begin
  FStorageSize := Size;
  while (Self.ControlCount > FStorageSize) do
    Self.Controls[Self.ControlCount - 1].Free;
end;

// TStorageItem

constructor TStorageItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCardCaption := '';
  FCaptionFont := TFont.Create;
  FCaptionFont.Size := FCaptionFont.Size + 2;
  FCaptionFont.Style := [fsBold];
  FRowCount := 0;
  FRowFont := Self.Font;
  FRowMargin := 2;
  FImageWidth := 50;
  FIconBitMap := nil;
  FBorderWidth := 10;
  FStretchWidth := False;
  FStretchHeight := False;
  FRows := TStringList.Create;
  FTask := TPrintTask.Create;;
  Self.BorderStyle := bsNone;
  Self.BevelOuter := bvNone;
  Self.BevelKind := bkFlat;
  Self.Color := clCream;
  Self.OnMouseEnter := Self.MouseEnter;
  Self.OnMouseLeave := Self.MouseLeave;
end;

destructor TStorageItem.Destroy;
begin
  Self.FIconBitMap.Free;
  Self.FRows.Free;
  Self.FTask.Free;
  inherited Destroy;
end;

procedure TStorageItem.SetIconBitMap(Source: TBitMap);
begin
  if FIconBitMap <> nil then FIconBitMap.Free;
  FIconBitMap := TBitMap.Create;
  FIconBitMap.Width := FImageWidth;
  FIconBitMap.Height := FImageWidth;
  FIconBitMap.Canvas.Brush.Color := clWhite;
  FIconBitMap.Canvas.FillRect(FIconBitMap.Canvas.ClipRect);
  FIconBitMap.Transparent := True;
  FIconBitMap.TransparentMode := tmAuto;
  if Source <> nil then CopyBitMap(FIconBitMap, Source)
    else CopyBitMap(FIconBitMap, TStoragePanel(Owner).DefItemBitMap)
end;

procedure TStorageItem.Paint;
var
  MainRct, Rct: TRect;
  TextFormat: TTextFormat;
  I, TextWidth: integer;
  Text: string;
begin
  inherited Paint;
  MainRct := Rect(FBorderWidth, FBorderWidth,
    Self.Width - FBorderWidth, FBorderWidth);
  TextFormat := [tfSingleLine, tfVerticalCenter, tfEndEllipsis];

  Rct := MainRct;
  if FIconBitMap <> nil then begin
    Self.Canvas.Draw(Self.FBorderWidth, Self.FBorderWidth, Self.FIconBitMap);
    Rct.Left := Rct.Left + Self.FImageWidth + Self.FBorderWidth;
  end else
    Rct.Left := Rct.Left + Self.FBorderWidth;

  Self.Canvas.Font := FCaptionFont;
  Rct.Bottom := Rct.Top + Self.Canvas.TextHeight(FCardCaption);
  TextWidth := Self.Canvas.TextWidth(FCardCaption);
  if (FStretchWidth) and (Rct.Right < (Rct.Left + TextWidth)) then
    Rct.Right := Rct.Left + TextWidth;
  Self.Canvas.TextRect(Rct, Self.FCardCaption, TextFormat);

  for I := 0 to Self.FRows.Count - 1 do begin
    Self.Canvas.Font := Self.FRowFont;
    Rct.Top := Rct.Bottom + Self.FRowMargin;
    Text := FRows.Strings[I];
    Rct.Bottom := Rct.Top + Self.Canvas.TextHeight(Text);
    Self.Canvas.TextRect(Rct, Text, TextFormat);
  end;

  if FStretchWidth then
    Self.Width := Rct.Right + FBorderWidth;
  if FStretchHeight then
    Self.Height := Rct.Bottom + FBorderWidth;
end;

procedure TStorageItem.AssignTask(Task: TPrintTask);
var
  Str: string;
begin
  FTask.Assign(Task);
  SetIconBitMap(Task.Product.BitMap);
  FCardCaption := Task.Model.Title;
  Rows.Clear;
  Rows.Add(Task.Shift.Title + '. '
    + FormatDateTime('dd mmmm yyyy', Task.Date));
  Str := 'C ' + IntTostr(Task.First) + ' по ' + IntTostr(Task.Last);
  Rows.Add(Str);
  Str := 'Форма: ' + Task.PrintForm;
  Rows.Add(Str);
  Str := 'Принтер: ' + Task.Printer;
  Rows.Add(Str);
end;

procedure TStorageItem.MouseEnter(Sender: TObject);
begin
  Self.Color := rgb (166, 189, 215);
  Screen.Cursor := crHandPoint;
end;

procedure TStorageItem.MouseLeave(Sender: TObject);
begin
  Self.Color := clCream;
  Screen.Cursor := crDefault;
end;

end.
