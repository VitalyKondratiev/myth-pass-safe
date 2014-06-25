unit appSettingsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, INIFiles, LazUtf8;

type

  { TappSettingsForm }

  TappSettingsForm = class(TForm)
    cancelBitBtn: TBitBtn;
    fileLastOpenCheckBox: TCheckBox;
    appMinimizeToTrayCheckBox: TCheckBox;
    OKBitBtn: TBitBtn;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    procedure appMinimizeToTrayCheckBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure windowHeaderImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure windowHeaderImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    mouseIsDown : Boolean; // Состояние удержания ЛКМ
    mPosX, mPosY : Integer; // Позиция курсора
  public
    { public declarations }
  end;


var
  appSettingsForm: TappSettingsForm;
  lminimizeToTray, lfileLastOpen: Boolean;
  cminimizeToTray, cfileLastOpen: Boolean;

implementation

uses
  functionsUnit;

{$R *.lfm}

{ TappSettingsForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TappSettingsForm.windowHeaderImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

procedure TappSettingsForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

procedure TappSettingsForm.appMinimizeToTrayCheckBoxChange(Sender: TObject);
begin
  if not (fileLastOpenCheckbox.Checked = appSettingsUnit.lfileLastOpen) or not (appMinimizeToTrayCheckBox.Checked = appSettingsUnit.lminimizeToTray) then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
end;

procedure TappSettingsForm.FormShow(Sender: TObject);
begin
  if lminimizeToTray then
    appMinimizeToTrayCheckBox.Checked := True
  else
    appMinimizeToTrayCheckBox.Checked := False;
  if lfileLastOpen then
    fileLastOpenCheckBox.Checked := True
  else
    fileLastOpenCheckBox.Checked := False;
end;

procedure TappSettingsForm.OKBitBtnClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  lminimizeToTray := appMinimizeToTrayCheckBox.Checked;
  lfileLastOpen := fileLastOpenCheckBox.Checked;
  IniFile:=TIniFile.Create(LazUtf8.UTF8ToSys('mythpass.ini'));
  IniFile.WriteBool('App','MinimalizeToTray', lminimizeToTray);
  IniFile.WriteBool('App','OpenLastFile', lfileLastOpen);
  IniFile.Destroy;
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TappSettingsForm.windowHeaderImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    appSettingsForm.Left := appSettingsForm.Left - mPosX + X; // Сдвиг формы по X
    appSettingsForm.Top := appSettingsForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TappSettingsForm.windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

end.

