program LabelPrint;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {frmMain},
  TaskStorageControl in 'Controls\TaskStorageControl.pas',
  LabelDataUnit in 'Models\LabelDataUnit.pas',
  DataListUnit in 'Models\DataListUnit.pas',
  DBControllerUnit in 'Controllers\DBControllerUnit.pas',
  SQLite3 in 'Source\SQLite3.pas',
  sqlite3udf in 'Source\sqlite3udf.pas',
  SQLiteTable3 in 'Source\SQLiteTable3.pas',
  PrintTaskUnit in 'Models\PrintTaskUnit.pas',
  SettingsDataUnit in 'Models\SettingsDataUnit.pas',
  PrintControllerDataModule in 'Controllers\PrintControllerDataModule.pas' {dmPrint: TDataModule},
  ConfirmPrinterForm in 'ConfirmPrinterForm.pas' {frmConfirmPrinter},
  TaskStorageFileControllerUnit in 'Controllers\TaskStorageFileControllerUnit.pas',
  DataStorageUnit in 'Models\DataStorageUnit.pas',
  SettingsForm in 'SettingsForm.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Печать штрихкодов V2';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmPrint, dmPrint);
  Application.CreateForm(TfrmConfirmPrinter, frmConfirmPrinter);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
