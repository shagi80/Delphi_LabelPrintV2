unit ConfirmPrinterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TfrmConfirmPrinter = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lbPrinterName: TLabel;
    Image1: TImage;
    btnConfirm: TBitBtn;
    btnChange: TBitBtn;
    procedure mbConfirmClick(Sender: TObject);
  private
    { Private declarations }
    FResult: TModalResult;
  public
    { Public declarations }
    function Confirm(PrinterName: string): TModalResult;
  end;

var
  frmConfirmPrinter: TfrmConfirmPrinter;

implementation

{$R *.dfm}

function TfrmConfirmPrinter.Confirm(PrinterName: string): TModalResult;
begin
  FResult := mrCancel;
  Self.lbPrinterName.Caption := PrinterName;
  Self.ShowModal;
  Result := FResult;
end;

procedure TfrmConfirmPrinter.mbConfirmClick(Sender: TObject);
begin
  if Sender = Self.btnConfirm then FResult := mrYes;
  if Sender = Self.btnChange then FResult := mrNo;
  Self.Close;
end;

end.
