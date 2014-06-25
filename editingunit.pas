unit editingUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, LazUtf8;

type

  { TeditingForm }

  TeditingForm = class(TForm)
    siteBitBtn: TBitBtn;
    loginBitBtn: TBitBtn;
    closeBitBtn: TBitBtn;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    procedure loginBitBtnClick(Sender: TObject);
    procedure siteBitBtnClick(Sender: TObject);
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
  editingForm: TeditingForm;

implementation

uses
  mainUnit, addSiteUnit, changeSiteUnit, deleteSiteUnit, addLoginUnit, changeLoginUnit,  deleteLoginUnit;

{$R *.lfm}

{ TeditingForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TeditingForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TeditingForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    editingForm.Left := editingForm.Left - mPosX + X; // Сдвиг формы по X
    editingForm.Top := editingForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TeditingForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TeditingForm.loginBitBtnClick(Sender: TObject);
begin
  case loginBitBtn.Caption of
    'Добавить логин':begin
      editingForm.Close;
      addLoginForm.siteNameComboBox.Items.LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      addLoginForm.ShowModal;
    end;
    'Изменить логин': begin
      editingForm.Close;
      changeLoginForm.siteNameComboBox.Items.LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      changeLoginForm.ShowModal;
    end;
    'Удалить логин': begin
      editingForm.Close;
      deleteLoginForm.siteNameComboBox.Items.LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      deleteLoginForm.ShowModal;
    end;
  end;
end;

procedure TeditingForm.siteBitBtnClick(Sender: TObject);
begin
  case siteBitBtn.Caption of
    'Добавить сайт': begin
      editingForm.Close;
      addSiteForm.ShowModal;
    end;
    'Изменить сайт': begin
      editingForm.Close;
      changeSiteForm.siteNameComboBox.Items.LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      changeSiteForm.ShowModal;
    end;
    'Удалить сайт': begin
      editingForm.Close;
      deleteSiteForm.siteNameComboBox.Items.LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      deleteSiteForm.ShowModal;
    end;
  end;
end;

end.

