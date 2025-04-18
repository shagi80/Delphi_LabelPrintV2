unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ImgList, PrintTaskUnit,
  Contnrs, frxClass, frxPreview, frxDesgn, frxDesgnCtrls;

type
  TfrmMain = class(TForm)
    pnTop: TPanel;
    btnBack: TSpeedButton;
    lbCaption: TLabel;
    pnBottom: TPanel;
    ilNewTask: TImageList;
    lvNewTask: TListView;
    imgDefProduct: TImage;
    pnMain: TPanel;
    pnTaskEdit: TPanel;
    Label1: TLabel;
    lbFactory: TLabel;
    cbFactory: TComboBox;
    Label3: TLabel;
    cbModel: TComboBox;
    cbShift: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    edCount: TEdit;
    edFirst: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    btnAdd50: TSpeedButton;
    btnAdd100: TSpeedButton;
    btnFirstCount: TSpeedButton;
    cbFormFile: TComboBox;
    btnPrint: TSpeedButton;
    Label6: TLabel;
    frxPreview: TfrxPreview;
    sbTaskStorage: TScrollBox;
    Bevel1: TBevel;
    btnSettings: TSpeedButton;
    dtpDate: TDateTimePicker;
    btnSavePrintForm: TSpeedButton;
    procedure btnSavePrintFormClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure edKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure lvNewTaskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClickChangeCount(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateNewTaskList(Sender: TObject);
    procedure UpdateEditTaskPanel(Sender: TObject);
    procedure EditTaskView(Sender: TObject);
    procedure UpdateComboBoxFromDataList(Box: TComboBox; Data: TObjectList);
    procedure UpdateModelDataList(Sender: TObject);
    procedure UpdatePrintFormList(Sender: TObject);
    function CanPrint: boolean;
    procedure SetTaskData;
    procedure AddTaskToStorage;
    procedure PosTaskStoragePanel;
    procedure SelectStorageTask(Sender: TObject);
    procedure CheckFactory;
    procedure OnChangeSettings;
  public
    { Public declarations }
  published
    procedure NewTaskView(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  TaskStorageControl, LabelDataUnit, DataStorageUnit, DBControllerUnit,
  SettingsDataUnit, PrintControllerDataModule, TaskStorageFileControllerUnit,
  SettingsForm;

const
  TASK_STORAGE_FILE = 'history.mdf';
  SETTINGS_FILE = 'settings.mdf';

var
  DataStorage: TDataStorage; // Хранилище задач
  CurrentTask: TPrintTask; // Текущая задача
  Settings: TSettingsData; // Список настроек
  pnTaskStorage: TStoragePanel; // Контрол списка задач
  FormPath: string; // Путь к каталого печатных форм

// События формы, инициализация переменных

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  DataStorage := TDataStorage.Create;
  CurrentTask := TPrintTask.Create;
  Settings := TSettingsData.Create(ExtractFilePath(Application.ExeName)
    + SETTINGS_FILE);
  pnTaskStorage := TStoragePanel.Create(Self.sbTaskStorage);
  pnTaskStorage.DefItemBitMap := Self.imgDefProduct.Picture.Bitmap;
  pnTaskStorage.OnSelectItem := Self.SelectStorageTask;
  Self.sbTaskStorage.InsertControl(pnTaskStorage);
  FormPath := ExtractFilePath(Application.ExeName) + 'PrintForm/';
  Self.NewTaskView(Self);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  pnTaskEdit.Top := pnMain.BorderWidth;
  pnTaskEdit.Left := pnMain.ClientWidth - pnTaskEdit.Width - pnMain.BorderWidth;
  frxPreview.Width := pnTaskEdit.Left - pnMain.BorderWidth;
  PosTaskStoragePanel;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  DBController: TDBController;
  TaskStorageFileController: TTaskStorageFileController;
begin
  dmPrint.frxReport.Preview := Self.frxPreview;
  dmPrint.FormPath := FormPath;
  // Загрузка данных из БД
  DBController := TDBController.Create;
  if not DBController.LoadtData(DataStorage) then begin
    MessageDlg('Ошибка загрузки данных о продукции !', mtWarning, [mbOk], 0);
    DBController.Free;
    Halt(1);
  end;
  DBController.Free;
  // Загрузка истории задач
  TaskStorageFileController := TTaskStorageFileController.Create(
    ExtractFilePath(Application.ExeName) + TASK_STORAGE_FILE);
  if TaskStorageFileController.Load(pnTaskStorage, DataStorage) then
    Self.PosTaskStoragePanel;
  TaskStorageFileController.Free;
  Self.UpdateNewTaskList(Self);
  Self.OnChangeSettings;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Controller: TTaskStorageFileController;
begin
  Settings.SaveToFile;
  Controller := TTaskStorageFileController.Create(TASK_STORAGE_FILE);
  Controller.Save(pnTaskStorage);
  Controller.Free;
end;

// События вида "Новая задача"

procedure TfrmMain.NewTaskView(Sender: TObject);
begin
  pnMain.Visible := False;
  lbCaption.Caption := 'Новая этикетка';
  lvNewTask.Align := alClient;
  lvNewTask.Visible := True;
  btnBack.Enabled := False;
  Self.Color := clWhite;
  edFirst.OnChange := nil;
  edCount.OnChange := nil;
end;

procedure TfrmMain.UpdateNewTaskList(Sender: TObject);
var
  I, ImgInd: integer;
  Bmp: TBitMap;
  Product: TProductData;
begin
  Self.lvNewTask.Items.Clear;
  Self.ilNewTask.Clear;
  Bmp := TBitMap.Create;
  Bmp.Width := ilNewTask.Width;
  Bmp.Height := ilNewTask.Height;
  for I := 0 to DataStorage.ProductList.Count - 1 do begin
    Product := DataStorage.ProductList[I];
    Bmp.Canvas.FillRect(Bmp.Canvas.ClipRect);
    if Product.BitMap <> nil then CopyBitMap(Bmp, Product.BitMap)
      else CopyBitMap(Bmp, Self.imgDefProduct.Picture.Bitmap);
    ImgInd := ilNewTask.Add(Bmp, nil);
    lvNewTask.AddItem(Product.Title, Product);
    lvNewTask.Items.Item[lvNewTask.Items.Count - 1].ImageIndex := ImgInd;
  end;
  Bmp.Free;
end;

procedure TfrmMain.lvNewTaskClick(Sender: TObject);
var
  I: integer;
begin
  if lvNewTask.Selected = nil then Exit;  
  CurrentTask.Assign(TProductData(lvNewTask.Selected.Data));
  for I := 0 to DataStorage.FactroyList.Count - 1 do
    if DataStorage.FactroyList[I].ID = Settings.DefFactoryId then
      CurrentTask.Factory := DataStorage.FactroyList[I];
  for I := 0 to DataStorage.ShiftList.Count - 1 do
    if DataStorage.ShiftList[I].ID = Settings.DefShiftId then
      CurrentTask.Shift := DataStorage.ShiftList[I];
  CurrentTask.Count := Settings.DefCount;
  CurrentTask.Printer := Settings.DefPrinterName;
  CurrentTask.Date := date;
  EditTaskView(Self);
  UpdateEditTaskPanel(Self);
end;

// События вида "Редактирование задачи"

procedure TfrmMain.EditTaskView(Sender: TObject);
begin
  lvNewTask.Visible := False;
  pnMain.Visible := True;
  pnMain.Align := alClient;
  btnBack.Enabled := True;
  lbCaption.Caption := CurrentTask.Product.Title;
  Self.OnResize(Self);
  Self.Color := clAppWorkSpace;
end;

procedure TfrmMain.UpdateComboBoxFromDataList(Box: TComboBox; Data: TObjectList);
var
  I, Ind: integer;
begin
  Box.Items.Clear;
  Ind := 0;
  for I := 0 to Data.Count - 1 do begin
    Box.Items.AddObject(TLabelData(Data[I]).Title, Data[I]);
    if CurrentTask <> nil then begin
      if (Box = cbFactory) and (CurrentTask.Factory = Data[I]) then Ind := I;
      if (Box = cbShift) and (CurrentTask.Shift = Data[I]) then Ind := I;
    end;
  end;
  if Box.Items.Count > 0 then Box.ItemIndex := Ind;
end;

procedure TfrmMain.UpdateModelDataList(Sender: TObject);
var
  I, Ind: integer;
begin
  cbModel.Items.Clear;
  Ind := 0;
  if CurrentTask <> nil then
    for I := 0 to DataStorage.ModelList.Count - 1 do
      if DataStorage.ModelList[I].ProductID = CurrentTask.Product.ID then begin
        cbModel.Items.AddObject(TLabelData(DataStorage.ModelList[I]).Title,
          DataStorage.ModelList[I]);
        if (CurrentTask.Model = DataStorage.ModelList[I]) then
          Ind := cbModel.Items.Count - 1;
      end;
  if cbModel.Items.Count > 0 then cbModel.ItemIndex := Ind;
end;

procedure TfrmMain.UpdatePrintFormList(Sender: TObject);
var
  SearchRec: TSearchRec;
  Ind: integer;
begin
  cbFormFile.Items.Clear;
  Ind := 0;
  if FindFirst(FormPath + '*.fr3', faAnyFile, SearchRec) = 0 then begin
    repeat
      if (SearchRec.Attr <> faDirectory) then begin
        cbFormFile.Items.Add(SearchRec.Name);
        if SearchRec.Name = CurrentTask.PrintForm then
          Ind := cbFormFile.Items.Count - 1;
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  if cbFormFile.Items.Count > 0 then cbFormFile.ItemIndex := Ind;  
end;

procedure TfrmMain.UpdateEditTaskPanel(Sender: TObject);
begin
  edFirst.OnChange := nil;
  edCount.OnChange := nil;
  UpdateComboBoxFromDataList(cbFactory, DataStorage.FactroyList);
  UpdateComboBoxFromDataList(cbShift, DataStorage.ShiftList);
  UpdateModelDataList(Self);
  edFirst.Text := IntToStr(CurrentTask.First);
  edCount.Text := IntToStr(CurrentTask.Count);
  UpdatePrintFormList(Self);
  btnPrint.Enabled := Self.CanPrint;
  dtpDate.Date := CurrentTask.Date;
  frxPreview.Visible := btnPrint.Enabled;
  if btnPrint.Enabled then begin
    edFirst.OnChange := Self.DataChange;
    edCount.OnChange := Self.DataChange;
    Self.DataChange(Self);
  end;
end;

function TfrmMain.CanPrint: boolean;
begin
  Result := ((CurrentTask <> nil)
    and (CurrentTask.Product <> nil)
    and (cbFactory.Items.Count > 0)
    and (cbModel.Items.Count >0)
    and (cbShift.Items.Count > 0)
    and (StrToIntDef(edFirst.Text, 0) > 0)
    and (StrToIntDef(edCount.Text, 0) > 0)
    and (StrToIntDef(edCount.Text, 0) <= 1000)
    and (cbFormFile.Items.Count > 0))
end;

procedure TfrmMain.CheckFactory;
begin
  if (Settings.DefFactoryId > 0) and (cbFactory.ItemIndex >= 0)
    and (TFactoryData(cbFactory.Items.Objects[cbFactory.ItemIndex]).ID
      <> Settings.DefFactoryId) then begin
        lbFactory.Font.Color := clRed;
        lbFactory.Font.Style := [fsBold];
      end else begin
        lbFactory.Font.Color := clBlack;
        lbFactory.Font.Style := [];
      end;
end;

procedure TfrmMain.ClickChangeCount(Sender: TObject);
var
  First, Count: integer;
begin
  First := StrToIntDef(edFirst.Text, 1);
  Count := StrToIntDef(edCount.Text, 100);
  if Sender = btnFirstCount then begin
    First := 1;
    Count := Settings.DefCount;
  end;
  if Sender = btnAdd50 then begin
    First := First + Count;
    Count := 50;
  end;
  if Sender = btnAdd100 then begin
    First := First + Count;
    Count := 100;
  end;
  edFirst.Text := IntToStr(First);
  edCount.Text := IntToStr(Count);
end;

procedure TfrmMain.edKeyPress(Sender: TObject; var Key: Char);
const
  Toolskey = [13, 8, 46, 38..40, 48..57];
begin
  if not(ord(Key) in ToolsKey) then Key := chr(0);
end;

procedure TfrmMain.SetTaskData;
begin
  if cbFactory.ItemIndex = -1 then CurrentTask.Factory := nil else
    CurrentTask.Factory := TFactoryData(cbFactory.Items.Objects[cbFactory.ItemIndex]);
  if cbModel.ItemIndex = -1 then CurrentTask.Model := nil else
    CurrentTask.Model := TModelData(cbModel.Items.Objects[cbModel.ItemIndex]);
  if cbShift.ItemIndex = -1 then CurrentTask.Shift := nil else
    CurrentTask.Shift := TShiftData(cbShift.Items.Objects[cbShift.ItemIndex]);
  CurrentTask.First := StrToIntDef(edFirst.Text, 1);
  CurrentTask.Count := StrToIntDef(edCount.Text, 1);
  if cbFormFile.ItemIndex = -1 then CurrentTask.PrintForm := '' else
    CurrentTask.PrintForm := cbFormFile.Items.Strings[cbFormFile.ItemIndex];
  CurrentTask.Date := dtpDate.Date;
end;

procedure TfrmMain.DataChange(Sender: TObject);
begin
  if Sender = Self.cbFactory then Self.CheckFactory;
  btnPrint.Enabled := Self.CanPrint;
  if (Sender <> edFirst) and (Sender <> edCount) then
    frxPreview.Visible := btnPrint.Enabled;
  if not btnPrint.Enabled then Exit;
  if Sender = edCount then Exit;
  SetTaskData;
  dmPrint.Preview(CurrentTask, Settings);
end;

procedure TfrmMain.btnPrintClick(Sender: TObject);
begin
  SetTaskData;
  if dmPrint.Print(CurrentTask, Settings) then AddTaskToStorage;
end;

// События истории задач

procedure TfrmMain.PosTaskStoragePanel;
begin
  pnTaskStorage.Top := 0;
  if pnTaskStorage.Width < sbTaskStorage.ClientWidth then
      pnTaskStorage.Left := trunc((sbTaskStorage.ClientWidth
        - pnTaskStorage.Width) /2 )
    else pnTaskStorage.Left := - sbTaskStorage.HorzScrollBar.Position;
end;

procedure TfrmMain.AddTaskToStorage;
begin
  pnTaskStorage.AddItem(CurrentTask);
  Self.PosTaskStoragePanel;
end;

procedure TfrmMain.SelectStorageTask(Sender: TObject);
begin
  CurrentTask.Assign(TStorageItem(Sender).Task);
  EditTaskView(Self);
  UpdateEditTaskPanel(Self);
  CheckFactory;
end;

// Изменение настроек

procedure TfrmMain.btnSavePrintFormClick(Sender: TObject);
var
  PrintForm: string;
  DBController: TDBController;
begin
  if cbFormFile.ItemIndex = -1 then Exit else
    PrintForm := cbFormFile.Items.Strings[cbFormFile.ItemIndex];
  DBController := TDBController.Create;
  DBController.SavePrintForm(CurrentTask.Product.ID, PrintForm);
  DBController.Free;
  ShowMessage('Форма сохранена !');
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  if frmSettings.EditSettings(DataStorage, Settings) then begin
    Self.OnChangeSettings;
  end;
end;

procedure TfrmMain.OnChangeSettings;
begin
  pnTaskStorage.StorageSize := Settings.DefStorageSize;
  btnFirstCount.Caption := '1-' + IntToStr(Settings.DefCount);
  btnSavePrintForm.Enabled := Settings.CanEditPrintForm;
  cbFormFile.Enabled := Settings.CanEditPrintForm;
  cbFactory.Enabled := not Settings.DontChangeFactory;
  if (pnMain.Visible) and (btnPrint.Enabled) then dmPrint.Preview(CurrentTask,
    Settings);
  Self.CheckFactory;
end;

end.
